variable "mc_server_config" {
  description = "Config params and location of scripts"
  type        = map(string)
  default = {
    instance_type     = "t2.xlarge"
    ecr_access_policy = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser" # policy used to to access ecr
    s3_access_policy = "arn:aws:iam::aws:policy/AmazonS3FullAccess" # s3 policy
    ecr_repo_name     = "test-aws-mc-server-ecr"
    # scripts 
    launch_server_script_loc = "../scripts/config-and-launch-server.bash"
  }
}

variable "s3_backup"{
  default = "data-for-mc-server"
}

variable "aws_region" {
  description = "Default AWS region for resources"
  default     = "us-east-1"
}

variable "ssh_cidr_firewall_list" {
  description = "CIDRs list allowed to connect to the ec2 mc server through SSH"
  default     = ["0.0.0.0/0"]
}


