
data "aws_caller_identity" "current" {}

output "container_url" {
  value = join("", ["http://", aws_instance.minecraft_server.public_dns])
}

# used in scripts 

output "aws_region" {
  value = var.aws_region # or use a data source to get the current region
}

output "ecr_repo_name" {
  value = var.mc_server_config["ecr_repo_name"]
}

output "s3_backup" {
  value = aws_s3_bucket.world_backup.id
}

output "ecr_repo_uri" {
  value = aws_ecr_repository.mc_server_kickstart.repository_url
}
