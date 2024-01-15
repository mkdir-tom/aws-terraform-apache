# Create Ec2 Instance On AWS Provider
resource "aws_instance" "my-web" {
  ami           = "my-ami-instance"
  instance_type = "t2.micro"
  availability_zone = "ap-southeast-1a"
  key_name = "my-web-key"

  network_interface {
    device_index         = 0
    network_interface_id = aws_network_interface.my-web-server-nic.id
  }

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -v "echo your very first my web service > /var/www/html/index.html"
              EOF

  tags          = {
    Name = "my-web"
  }
}