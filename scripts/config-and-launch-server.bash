#!bin/bash

# aws ec2 with amazonlinux
sudo yum update -y
sudo yum install docker -y

sudo systemctl enable docker
sudo systemctl start docker

# pulling latest backup image from ecr
# /.env
echo "ECR_REPO_NAME=${ECR_REPO_NAME}" >> .env
echo "ECR_REPO_URI=${ECR_REPO_URI}" >> .env
echo "AWS_REGION=${AWS_REGION}" >> .env

# set the env variables


aws ecr get-login-password --region ${AWS_REGION} | \
sudo docker login --username AWS --password-stdin ${ECR_REPO_URI}

sudo docker pull ${ECR_REPO_URI}

# sudo docker run -it 381492252728.dkr.ecr.us-east-1.amazonaws.com/minecraft-server-fiis