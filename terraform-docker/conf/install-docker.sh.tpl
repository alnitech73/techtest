#! /bin/bash
sudo mkdir -p /data/docker
sudo mkdir /etc/docker
sudo cat > /etc/docker/docker.json <<EOF
{
    "data-root": "${docker_data_dir}"
}
EOF
sudo apt-get -y update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu  $(lsb_release -cs)  stable"
sudo apt-get -y update
sudo apt-get -y install docker-ce=${docker_version}
sudo groupadd docker
sudo usermod -aG docker ubuntu
sudo systemctl start docker
sudo systemctl enable docker
