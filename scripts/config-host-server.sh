#!bin/bash

# aws ec2 with amazonlinux
sudo yum update -y
sudo yum install docker -y

sudo systemctl enable docker
sudo systemctl start docker


