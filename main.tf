module "networking" {
source = "./modules/networking"
  region               = var.region
  environment          = "dev"
  vpc_cidr             = "172.19.0.0/16"
  public_subnets_cidr  = ["172.19.0.0/20", "172.19.16.0/20", "172.19.32.0/20"]
  private_subnets_cidr = ["172.19.48.0/20", "172.19.64.0/20", "172.19.80.0/20"]
  availability_zones   = ["us-east-1a","us-east-1b","us-east-1c"]
}

module "ec2" {
source = "./modules/ec2"
  ami                     = "ami-059f1cc52e6c85908"
  vpc_security_group_ids  = ["${module.networking.security_group.id}"]
  gitaly-instance-type    = "t3.medium"
  gitaly-private-subnet   = "${module.networking.private_subnet[0].id}"
  praefect-instance-type  = "t3.medium"
  mon-instance-type       = "t3.medium"
  app-instance-type       = "t3.medium"
  app-public-subnet      = "${module.networking.public_subnet[0].id}"
}
