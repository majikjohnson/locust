variable "key_name" {
  description = "The name of the PKI key pair to use"
  type        = string
}

variable "server_count" {
  description = "The number of servers to create"
  type        = number
  default     = 1
}

variable "locust_role" {
  description = "The role of the server.  Either master or slave"
  type        = string
}

variable "ami" {
  description = "The AWS AMI to use"
  type        = string
}

variable "instance_type" {
  description = "The AWS AMI to use"
  type        = string
}

variable "subnet_id" {
  description = "The AWS VPC Subnet ID"
  type        = string
}

variable "security_group_ids" {
  description = "The AWS Security Group Ids"
  type        = list(string)
}


