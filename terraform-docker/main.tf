data "aws_vpc" "default" {
  default = true
}

# Learn my public IP address
data "http" "ifconfig" {
   url = "http://ifconfig.me"
}

# Create the security group to allow incoming to 80/443 ports from anywhere
module "ec2_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2_sg"
  description = "Security group for ec2_sg"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "all-icmp"]
  egress_rules        = ["all-all"]
}

# Create the security group to allow SSH only from tf client IP so it can connect with docker provider
module "ssh_sg" {
  source = "terraform-aws-modules/security-group/aws"

  name        = "ec2_sg"
  description = "Security group for ec2_sg"
  vpc_id      = data.aws_vpc.default.id

  ingress_cidr_blocks = ["${data.http.ifconfig.response_body}/32"]
  ingress_rules       = ["ssh-tcp"]
}

# Generate SSH key
resource "tls_private_key" "this" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Save the private key locally. needed by docker provider
resource "local_sensitive_file" "priv_key" {
  filename = pathexpand("~/.ssh/${local.key_name}.pem")
  file_permission = "600"
  content = tls_private_key.this.private_key_pem
}

# Save the public key in AWS
resource "aws_key_pair" "this" {
  key_name   = local.key_name
  public_key = tls_private_key.this.public_key_openssh
}

# Let's read the ami available based on the filter
data "aws_ami" "this" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/*hvm-ssd*ubuntu-*-${local.ubuntu_version}-amd64-server-*"]
  }
}

# Create the instance and install docker on it
resource "aws_instance" "dockertest" {
  ami           = data.aws_ami.this.id
  instance_type = "t3.micro"

  root_block_device {
    volume_size = 20
  }

  vpc_security_group_ids = [
    module.ec2_sg.security_group_id,
  ]

  user_data = templatefile("${path.module}/conf/install-docker.sh.tpl",
      {
          docker_version = local.docker_version
          docker_data_dir = local.docker_data_dir
      }
  )

  tags = {
    Name ="dockertest"
  }

  key_name                = aws_key_pair.this.key_name
  monitoring              = true
#   disable_api_termination = false
#   ebs_optimized           = true
}

# Once doker is installed using docker terraform provider let's pull nginx image
resource "docker_image" "nginx" {
  name = "nginx"
}

# Run the docker image and we'll output some atributes as requested
resource "docker_container" "nginx" {
  name  = "nginx"
  image = docker_image.nginx.image_id
}