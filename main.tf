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
  ami                       = "ami-059f1cc52e6c85908"
  vpc_security_group_ids    = ["${module.networking.security_group.id}"]
  gitaly-instance-type      = "t3.medium"
  gitaly-private-subnet     = "${module.networking.private_subnet[0].id}"
  praefect-instance-type    = "t3.medium"
  praefect-private-subnet   = "${module.networking.private_subnet[0].id}"
  mon-instance-type         = "t3.medium"
  mon-private-subnet        = "${module.networking.private_subnet[0].id}"
  app-instance-type         = "t3.medium"
  app-private-subnet        = "${module.networking.private_subnet[0].id}"
  bastion-instance-type     = "t3.medium"
  bastion-public-subnet     = "${module.networking.public_subnet[0].id}"
}

module "rds" {
source = "./modules/rds"
  private-subnets           = ["${module.networking.private_subnet[0].id}","${module.networking.private_subnet[1].id}","${module.networking.private_subnet[2].id}"]
  instance-type             = "db.t3.medium"
  gitlab-dbname             = "gitlabpg"
  gitlab-username           = "gitlab"
  gitlab-password           = "Compaq1!"
  praefect-dbname           = "praefect"
  praefect-username         = "praefect"
  praefect-password         = "Compaq1!"
  vpc_security_group_ids    = ["${module.networking.security_group.id}"]
}

module "elasticache" {
source = "./modules/elasticache"
  private-subnets           = ["${module.networking.private_subnet[0].id}","${module.networking.private_subnet[1].id}","${module.networking.private_subnet[2].id}"]
  availability_zones        = ["us-east-1a"]
  instance-type             = "cache.t3.medium"
  vpc_security_group_ids    = ["${module.networking.security_group.id}"]
}

module "eks" {
source = "./modules/eks"
  private-subnets           = ["${module.networking.private_subnet[0].id}","${module.networking.private_subnet[1].id}","${module.networking.private_subnet[2].id}"]
  instance-type             = "t3.medium"
}

module "lb" {
source = "./modules/lb"
  private-subnets           = ["${module.networking.private_subnet[0].id}","${module.networking.private_subnet[1].id}","${module.networking.private_subnet[2].id}"]
  vpc_security_group_ids    = ["${module.networking.security_group.id}"]
  vpc_id                    = module.networking.vpc_id
  public-subnets            = ["${module.networking.public_subnet[0].id}","${module.networking.public_subnet[1].id}","${module.networking.public_subnet[2].id}"]
  app-instances             = module.ec2.app-instances
  praefect-instances        = module.ec2.praefect-instances
  mon-instances             = module.ec2.mon-instances
}

module "route53" {
source = "./modules/route53"
  rh-zoneid                 = "/hostedzone/Z1N2PXZSW9EYEB"
  lab-dns-zone              = "sandbox783.opentlc.com."
  app-zone-id               = module.lb.application_zone_id
  app-dns-name              = module.lb.application_elb
  storage-zone-id           = module.lb.storage_zone_id
  storage-dns-name          = module.lb.storage_elb
  mon-zone-id               = module.lb.mon_zone_id
  mon-dns-name              = module.lb.monitoring_elb
}

module "s3" {
source = "./modules/s3"
}

module "ansible" {
source = "./modules/ansible"
#  app-instance-public-ip   = module.ec2.app-public-dns
  app-instances-ip          = module.ec2.app-1-private-dns
  gitaly-instances-ip       = module.ec2.gitaly-1-private-dns
  praefect-instances-ip     = module.ec2.praefect-1-private-dns
  mon-instances-ip          = module.ec2.mon-1-private-dns
  gitlab-lb-url             = module.lb.application_elb
  gitlab_version            = "15.0.4"
  praefect_internal_token   = "BFGSn2jdHtCvbacG"
  praefect_external_token   = "YDjg8YRpQnQeTEBm"
  gitlab_root_password      = "Compaq1!"
  grafana_admin_password    = "Compaq1!"
  praefect-database-endpoint  = module.rds.praefect_database_endpoint
  praefect-db-username      = "praefect"
  praefect-db-password      = module.rds.praefect_database_password
  praefect-db-name          = "praefect"
  gitlab-gui                = module.route53.gitlab-gui
  gitlab-pages              = module.route53.gitlab-pages
  gitlab-registry           = module.route53.gitlab-registry
  gitlab-region             = var.region
  gitlab-database-endpoint  = module.rds.gitlab_database_endpoint
  gitlab-db-name            = "gitlabpg"
  gitlab-db-username        = "gitlab"
  gitlab-db-password        = module.rds.gitlab_database_password
  elasticache_endpoint      = module.elasticache.elasticache_endpoint
  s3-registry               = module.s3.s3-registry
  s3-backup                 = module.s3.s3-backup
  s3-artifacts              = module.s3.s3-artifacts
  s3-uploads                = module.s3.s3-uploads
  s3-diffs                  = module.s3.s3-diffs
  s3-lfs                    = module.s3.s3-lfs
  monitoring_elb            = module.lb.monitoring_elb
  praefect-lb-url           = module.lb.storage_elb
}
