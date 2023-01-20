provider "aws" {
  region = "us-east-1"
}

provider "docker" {
  host     = "ssh://ubuntu@${aws_instance.dockertest.public_dns}:22"
  ssh_opts = ["-i", "${local_sensitive_file.priv_key.filename}", "-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null"]
}