## Main Resources

# Default vpc
data "aws_vpc" "default_vpc" {
  default = true
}

# Minecraft server ec2 instance
resource "aws_instance" "minecraft_server" {
  ami                    = "ami-0e36db3a3a535e401" # amazonlinux 2023 arm for us-east-1
  instance_type          = var.mc_server_config["instance_type"]
  # don't care for the availability zone yet
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name # ecr policy role
  user_data = file(var.mc_server_config["launch_server_script_loc"])
  tags = {
    Name = "Minecraft Server"
  }
}

# ECR registry to backup and restore the server
resource "aws_ecr_repository" "mc_server_backup" {
  name = var.mc_server_config["ecr_repo_name"]
  image_tag_mutability = "MUTABLE"
}

# ECR policy for the server
resource "aws_ecr_lifecycle_policy" "mc_server_lifecycle_policy" {
  repository = aws_ecr_repository.mc_server_backup.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 10
        description = "Keep last 2 images"
        selection = {
          tagStatus = "tagged"
          tagPrefixList = ["v"]
          countType = "imageCountMoreThan"
          countNumber = 2
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

