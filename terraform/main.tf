provider "aws" {
  # profile = "default"  - not needed.  Automatically picked up from %USERPROFILE%\.aws\credentials
  region = var.region
}

resource "aws_key_pair" "terraform_key" {
  key_name   = "terraform_key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDZmiNwqop269dPg6fP9xmwaEmWV7BSQ0gYnKr27/8FPWM8EF21GJI0mlWqjHKz5D1QCRx+3RX/70Wd6oUOQu03HjUVXAtDi9etxD9ygSXIBg+CZclkKNkzuoNpVb5zS0P6AtW5KXa0UhFGGXbfBEgqPrmMcRy64n1+4KH9sLNiZl4KRFhHfw4BIRG7lAUOQXdO8QWL4BEl+5+j1KTNEoh2OOIFhhbHsnNWcEjtBNgkT/lVoiESa1/nIUOrEpOmM1iF779cNBgSRDHxMqZ/ruKAfCgACJikFAbzwSuZq+tdWVzktcNi7GIcwYhqgSVIconQM89TVZ62r8yR99u7dAFw64kJpt3NUYVY2Rxq4sKx+SAGSXhJvERR90tFYBA+StOH0jBv9RfIbWV6WcMFRRgVx+sBUtolhe3jgWNMmA7AG/bKlhoORx+06QQvvzlfpl//W798M5vI2ISSlWM1KyOrPxr58pnmu+M/kbgRD59y7YBzX/vCzvaImXaucGZrLOU= Matt@family-pc"
}

module "locust_network" {
  source = "./Modules/Networking"
}

module "locust_security_groups" {
  source = "./Modules/SecurityGroups"

  vpc_id         = module.locust_network.vpc_id
  master_name = "locust-master"
  slave_name  = "locust-slave"
}

module "locust_master" {
  source = "./Modules/Servers"

  locust_role        = "master"
  server_count       = 1
  ami                = var.locust_ami
  instance_type      = var.locust_master_instance_type
  key_name           = aws_key_pair.terraform_key.key_name
  subnet_id          = module.locust_network.subnet_id
  security_group_ids = [module.locust_security_groups.id_slave]

}

module "locust_slaves" {
  source = "./Modules/Servers"

  locust_role        = "slave"
  server_count       = 2
  ami                = var.locust_ami
  instance_type      = var.locust_slave_instance_type
  key_name           = aws_key_pair.terraform_key.key_name
  subnet_id          = module.locust_network.subnet_id
  security_group_ids = [module.locust_security_groups.id_slave]
}


