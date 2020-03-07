output "sg_id_locust_master" {
  value = aws_security_group.locust_master.id
}

output "sg_id_locust_slave" {
  value = aws_security_group.locust_slave.id
}