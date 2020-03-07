variable "vpc_id" {
  description = "The AWS VPC ID that this Security Group attaches to"
}

variable "master_sg_name" {
  description = "The name of the Security Group"
  default     = "master"
}

variable "slave_sg_name" {
  description = "The name of the Security Group"
  default     = "slave"
}

