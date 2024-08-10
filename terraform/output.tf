
output "container_url" {
  value = join("", ["http://", aws_instance.minecraft_server.public_dns])
}

# used in scripts 

output "aws_region" {
  value = var.aws_region  # or use a data source to get the current region
  }

output "ecr_repo_name" {
  value = var.mc_server_config["ecr_repo_name"]
}

output "ecr_repo_uri" {
    value = aws_ecr_repository.mc_server_backup.repository_url
}