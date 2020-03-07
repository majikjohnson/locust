variable "region" {
  description = "The AWS region to use."
  type        = string
  default     = "us-east-1"
}

variable "locust_ami" {
  description = "The AWS image name to use for the locust master."
  type        = string
  default     = "ami-0c322300a1dd5dc79"
}

variable "locust_master_instance_type" {
  description = "The AWS EC2 instance type to use for the locust master."
  type        = string
  default     = "t2.micro"
}

variable "locust_slave_instance_type" {
  description = "The AWS EC2 instance type to use for the locust slave."
  type        = string
  default     = "t2.micro"
}

variable "slave_count" {
  description = "Number of locust slave nodes to initialise"
  type        = number
  default     = 2
}

