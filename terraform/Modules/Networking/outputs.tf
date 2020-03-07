output "vpc_id" {
  value = aws_vpc.locust.id
}

output "subnet_id" {
  value = aws_subnet.locust.id
}