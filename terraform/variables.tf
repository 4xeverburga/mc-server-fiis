variable "instance_type" {
  description = "The type of EC2 instance to launch"
  default     = "c4.2xlarge"
}

variable "dockerfile_path" {
  description = "The path to the Dockerfile"
  default     = "../dockerfile"
}

variable "deployment_script_path" {
  description = "The path to the deployment script"
  default     = "../scripts/config-host-server.sh"
}

variable "ec2_role" {
  description = "The IAM role for the EC2 instance"
  default     = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}
