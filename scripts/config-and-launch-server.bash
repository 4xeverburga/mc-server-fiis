#!bin/bash

# sync does not work in /
cd /home/ec2-user
touch launch-log.txt

# aws ec2 with amazonlinux
sudo yum update -y
sudo yum install docker -y
sudo yum install cronie -y # crontab

sudo systemctl enable docker
sudo systemctl start docker

# pulling latest kickstart image from ecr
# /.env
echo "ECR_REPO_NAME=${ECR_REPO_NAME}" >> .env
echo "ECR_REPO_URI=${ECR_REPO_URI}" >> .env
echo "AWS_REGION=${AWS_REGION}" >> .env
echo "BACKUP_BUCKET=${BACKUP_BUCKET}" >> .env

# pull and kickstart initial image
aws ecr get-login-password --region ${AWS_REGION} | sudo docker login --username AWS --password-stdin ${ECR_REPO_URI}

sudo docker pull ${ECR_REPO_URI}
sudo docker tag ${ECR_REPO_URI} mc:latest # rename
sudo docker image ls >> launch-log.txt # log

# sync from s3
mkdir world
aws s3 sync s3://${BACKUP_BUCKET} .

# install of docker-compose plugin i found in 
# https://stackoverflow.com/questions/63708035/installing-docker-compose-on-amazon-ec2-linux-2-9kb-docker-compose-file

sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# systemd minecraft service
sudo cp scripts/mc-server.service /etc/systemd/system/mc-server.service
sudo systemctl daemon-reload
sudo systemctl enable mc-server.service

# cronjob
sudo systemctl enable crond.service
sudo systemctl start crond.service
# hourly backup
sudo cp scripts/backup-cron.bash /etc/cron.hourly/backup-cron.bash
sudo chmod +x /etc/cron.hourly/backup-cron.bash

# start server
sudo systemctl start mc-server.service