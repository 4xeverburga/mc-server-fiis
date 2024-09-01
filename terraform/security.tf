## Security Group for the ec2 instance
resource "aws_security_group" "ec2_security_group" {
  description = "Reglas de ingreso para el puerto 25565 de minecraft"
  vpc_id      = data.aws_vpc.default_vpc.id

  ingress {
    description = "tcp access for minecraft server"
    from_port   = 25565
    to_port     = 25565
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh access for debugging"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_cidr_firewall_list # CIDRs whitelisted
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}


## IAM resources

# configuring the aws role for ec2
resource "aws_iam_role" "ec2_role" {
  name = "minecraft_ec2_role"
  # trust policy
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_policy" {
  role = aws_iam_role.ec2_role.name
  # permission policy
  policy_arn = var.mc_server_config["ecr_access_policy"]
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  role = aws_iam_role.ec2_role.name
  # permission policy
  policy_arn = var.mc_server_config["s3_access_policy"]
}


resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "minecrafta_ec2server_instance_profile"
  role = aws_iam_role.ec2_role.name
}
