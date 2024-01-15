subnet_prefix = [{ cidr_block = "10.0.1.0/24", availability_zone = "ap-southeast-1a" }]
ec2           = { ami = "my-ami-instance", instance_type = "t2.micro", key_name = "my-web-key" }