variable "ami" {}
variable "vpc_security_group_ids" {}

variable "gitaly-instance-type" {}
variable "gitaly-private-subnet" {}

variable "praefect-instance-type" {}
variable "praefect-private-subnet" {}

variable "mon-instance-type" {}
variable "mon-private-subnet" {}

variable "app-instance-type" {}
#variable "app-private-subnet" {}
variable "app-public-subnet" {}

variable "bastion-instance-type" {}
variable "bastion-public-subnet" {}

