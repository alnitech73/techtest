output "public_dns" {
  value     = aws_instance.dockertest.public_dns
}

output "container" {
  value     = {
    id = docker_container.nginx.id
    name = docker_container.nginx.name
    hostname = docker_container.nginx.hostname
    ip = docker_container.nginx.network_data[0].ip_address
    gateway = docker_container.nginx.network_data[0].gateway
  }
}



