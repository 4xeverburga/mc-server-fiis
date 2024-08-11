#!bin/bash

# aws ec2 with amazonlinux
sudo yum update -y
sudo yum install docker -y

sudo systemctl enable docker
sudo systemctl start docker

# BUG: no autentica, seguramente alguna(s) variables no son correctas
# pulling latest backup image from ecr
ECR_REPO_NAME = $(terraform output -raw ecr_repo_name)
ECR_REPO_URI = $(terraform output -raw ecr_repo_uri) 
AWS_REGION = $(terraform output -raw aws_region)

aws ecr get-login-password --region ${AWS_REGION} | \
sudo docker login --username AWS --password-stdin ${ECR_REPO_URI}

sudo docker pull ${ECR_REPO_URI}

# sudo docker run -it 381492252728.dkr.ecr.us-east-1.amazonaws.com/minecraft-server-fiis