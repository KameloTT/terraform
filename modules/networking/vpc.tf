module "vpc" {
  source                       = "terraform-aws-modules/vpc/aws"
#  version                      = "2.44.0"
  name                         = var.pname
  cidr                         = var.vpc_cidr
  azs                          = data.aws_availability_zones.current.names
  public_subnets               = var.public_subnets_cidr
  private_subnets              = var.private_subnets_cidr
  enable_dns_hostnames         = true
  enable_dns_support           = true
  enable_nat_gateway           = true
  one_nat_gateway_per_az       = false
  single_nat_gateway           = true
  tags = {
    Environment = "${var.environment}"
    app = var.pname
  }
}

data "aws_region" "current" {}

data "aws_availability_zones" "current" {
  all_availability_zones = true
  filter {
    name   = "zone-name"
    values = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  }
}

resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default security group to allow inbound/outbound from the VPC"
  vpc_id      = module.vpc.vpc_id
#  depends_on  = module.vpc

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
  }

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
  }
  tags = {
    Environment = "${var.environment}"
    app = var.pname
  }
}
