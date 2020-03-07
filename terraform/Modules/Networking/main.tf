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