output "container_url" {
  value = join("", ["http://", aws_instance.ec2_instance.public_dns])
}
