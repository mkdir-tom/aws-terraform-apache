# Configure the AWS Provider
provider "aws" {
  region     = "ap-southeast-1"
  access_key = "my-access-key"
  secret_key = "my-secret-key"
}

# 1. Create vpc
# 2. Create Internet Gateway
# 3. Create Custom Route Table
# 4. Create a Subnet
# 5. Associate subnet with Route Table
# 6. Create Security Group to allow port 22,80,443
# 7. Create a network interface with an ip in the subnet that was created in step 4
# 8. Assign an elastic IP to the network interface created in step 7
# 9. Create Ubuntu server and install/enable apache2

# terraform init
# terraform plan
# terraform apply
# terraform state list
# terraform state show name
# terraform destroy --auto-approve