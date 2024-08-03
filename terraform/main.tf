resource "aws_instance" "ec2_instance" {
  ami                    = data.aws_ami.amazon_linux_2.id
  instance_type          = var.instance_type
  subnet_id              = aws_default_subnet.default_az1.id
  vpc_security_group_ids = [aws_security_group.ec2_security_group.id]
  key_name               = "ec2_key"
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name

  tags = {
    Name = "docker server"
  }
}
resource "null_resource" "name" {

  provisioner "file" {
   source      = "~/Downloads/docker_password.txt"
   destination = "/home/ec2-user/docker_password.txt"

   }
  # copy the dockerfile from your computer to the ec2 instance
  provisioner "file" {
    source      = var.dockerfile_path
    destination = "/home/ec2-user/Dockerfile"
  }

  provisioner "file" {
    source      = var.deployment_script_path
    destination = "/home/ec2-user/deployment.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo chmod +x /home/ec2-user/deployment.sh",
      "sh /home/ec2-user/deployment.sh",

    ]
  }

  depends_on = [aws_instance.ec2_instance]

}

