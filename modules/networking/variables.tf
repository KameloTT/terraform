variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  description = "The CIDR block for the public subnet"
}

variable "private_subnets_cidr" {
  description = "The CIDR block for the private subnet"
}

variable "environment" {
  description = "The environment"
}

variable "region" {
  description = "The region to launch the bastion host"
}

variable "availability_zones" {
  description = "The az that the resources will be launched"
}
