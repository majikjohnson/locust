provider "aws" {
  # profile = "default"  - not needed.  Automatically picked up from %USERPROFILE%\.aws\credentials
  region = "us-east-1"
}

resource "aws_vpc" "locust" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}

resource "aws_subnet" "locust" {
  vpc_id     = aws_vpc.locust.id
  cidr_block = "10.0.1.0/24"
}

resource "aws_internet_gateway" "locust" {
  vpc_id = aws_vpc.locust.id
}

resource "aws_route" "locust_internet" {
  # It appears that a routing table is created automatically when creating a VPC.  Therefore just need to add the route
  route_table_id         = aws_vpc.locust.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.locust.id
}

resource "aws_security_group" "locust_master" {
  vpc_id = aws_vpc.locust.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP on Locust default port"
    from_port   = 8089
    to_port     = 8089
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Internet access"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZmiNwqop269dPg6fP9xmwaEmWV7BSQ0gYnKr27/8FPWM8EF21GJI0mlWqjHKz5D1QCRx+3RX/70Wd6oUOQu03HjUVXAtDi9etxD9ygSXIBg+CZclkKNkzuoNpVb5zS0P6AtW5KXa0UhFGGXbfBEgqPrmMcRy64n1+4KH9sLNiZl4KRFhHfw4BIRG7lAUOQXdO8QWL4BEl+5+j1KTNEoh2OOIFhhbHsnNWcEjtBNgkT/lVoiESa1/nIUOrEpOmM1iF779cNBgSRDHxMqZ/ruKAfCgACJikFAbzwSuZq+tdWVzktcNi7GIcwYhqgSVIconQM89TVZ62r8yR99u7dAFw64kJpt3NUYVY2Rxq4sKx+SAGSXhJvERR90tFYBA+StOH0jBv9RfIbWV6WcMFRRgVx+sBUtolhe3jgWNMmA7AG/bKlhoORx+06QQvvzlfpl//W798M5vI2ISSlWM1KyOrPxr58pnmu+M/kbgRD59y7YBzX/vCzvaImXaucGZrLOU= Matt@family-pc"
}

resource "aws_instance" "locust_master" {
  key_name                    = aws_key_pair.terraform_key.key_name
  ami                         = "ami-0c322300a1dd5dc79"
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.locust_master.id]
  subnet_id                   = aws_subnet.locust.id
  associate_public_ip_address = true

  tags = {
    Name = "LocustMaster"
  }
}

