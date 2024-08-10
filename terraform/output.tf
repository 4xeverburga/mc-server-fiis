output "container_url" {
  value = join("", ["http://", aws_instance.minecraft_server.public_dns])
}
