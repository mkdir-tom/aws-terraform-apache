variable "ec2" {}
# Create Ec2 Instance On AWS Provider
resource "aws_instance" "my-web" {
  ami               = var.ec2.ami
  instance_type     = var.ec2.instance_type
  availability_zone = "ap-southeast-1a"
  key_name          = var.ec2.key_name

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.my-web-server-nic.id
  }

  user_data = file("files-sh/apache2.sh")

  #  user_data = join("", [
  #    file("files-sh/apache2.sh"),
  #    file("files-sh/nginx.sh")
  #  ])

  tags = {
    Name = "my-web"
  }
}