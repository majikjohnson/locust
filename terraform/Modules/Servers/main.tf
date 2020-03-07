resource "aws_instance" "locust_server" {
  key_name                    = var.key_name
  count                       = var.server_count
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  tags = {
    Name = var.locust_role
  }
}