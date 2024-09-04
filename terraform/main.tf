## Main Resources

# Default vpc
data "aws_vpc" "default_vpc" {
  default = true
}

# Minecraft server ec2 instance
resource "aws_instance" "minecraft_server" {
  depends_on = [ null_resource.docker_image_push, null_resource.cp_data_to_s3 ] # i'll be using this image and s3 initial backup here in user_data
  ami           = "ami-066784287e358dad1" # amazonlinux 2023 amd for us-east-1
  instance_type = var.mc_server_config["instance_type"]
  # don't care for the availability zone yet
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  iam_instance_profile   = aws_iam_instance_profile.ec2_instance_profile.name # ecr policy role
  user_data = templatefile(var.mc_server_config["launch_server_script_loc"], {
    ECR_REPO_NAME = var.mc_server_config["ecr_repo_name"],
    ECR_REPO_URI  = aws_ecr_repository.mc_server_kickstart.repository_url,
    AWS_REGION    = var.aws_region,
    BACKUP_BUCKET= var.s3_backup
  }) # adds the rendered template 
  tags = {
    Name = "Minecraft Server"
  }
}
 
# ECR registry to kickstart the server
resource "aws_ecr_repository" "mc_server_kickstart" {
  name                 = var.mc_server_config["ecr_repo_name"]
  force_delete = true # this way, the repo can be deleted even with images in it
  image_tag_mutability = "MUTABLE"
}



# ECR policy for the image registry
resource "aws_ecr_lifecycle_policy" "mc_server_lifecycle_policy" {
  repository = aws_ecr_repository.mc_server_kickstart.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 2 images"
        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"]
          countType      = "imageCountMoreThan"
          countNumber    = 2
        }
        action = {
          type = "expire"
        }
      }
    ]
  })
}

# s3 backup for /world
# add history with a lifecycle policy

resource "aws_s3_bucket" "world_backup" {
  # force_destroy = true # NOTE: uncomment if you want to also remove world data
  bucket = var.s3_backup
}

resource "aws_s3_bucket_versioning" "s3_versioning" {
  bucket = aws_s3_bucket.world_backup.id
  versioning_configuration {
    status = "Enabled"
  }
}



# Docker image push running at the root project dir
resource "null_resource" "docker_image_push" {
  depends_on = [ aws_ecr_repository.mc_server_kickstart ] # i want to push to this ecr
  provisioner "local-exec" {
    working_dir = "../"
    command = <<EOF
    aws ecr get-login-password --region ${var.aws_region} | \
    sudo docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.us-east-1.amazonaws.com;
     
    sudo docker tag mc:latest "${aws_ecr_repository.mc_server_kickstart.repository_url}:latest" 
	  sudo docker push "${aws_ecr_repository.mc_server_kickstart.repository_url}:latest"
    EOF
  }
}

resource "null_resource" "cp_data_to_s3" {
  # NOTE: you can't sync a single file without using exclude and include
  depends_on = [aws_s3_bucket.world_backup] # this is the bucket i want to sync with
  provisioner "local-exec" {
    working_dir = "../"
    command = <<EOF
      aws s3 cp ./world/ s3://${var.s3_backup}/world/ --recursive
      aws s3 cp ./docker-compose-ec2.yml s3://${var.s3_backup}/docker-compose.yml
      aws s3 sync ./scripts/host-machine/ s3://${var.s3_backup}/scripts
    EOF
  }
}
