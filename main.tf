module "networking" {
source = "./modules/networking"
  region               = var.region
  environment          = "dev"
  vpc_cidr             = "172.19.0.0/16"
  public_subnets_cidr  = ["172.19.0.0/20", "172.19.16.0/20", "172.19.32.0/20"]
  private_subnets_cidr = ["172.19.48.0/20", "172.19.64.0/20", "172.19.80.0/20"]
  availability_zones   = ["us-east-1a","us-east-1b","us-east-1c"]
#  public_subnets_cidr  = ["172.19.0.0/20"]
#  private_subnets_cidr = ["172.19.48.0/20"]
#  availability_zones   = ["us-east-1a"]
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
#  app-private-subnet        = "${module.networking.private_subnet[0].id}"
  app-public-subnet     = "${module.networking.public_subnet[0].id}"
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
#  private-subnets           = ["${module.networking.private_subnet[0].id}","${module.networking.private_subnet[1].id}","${module.networking.private_subnet[2].id}"]
  private-subnets           = ["${module.networking.private_subnet[0].id}"]
  vpc_security_group_ids    = ["${module.networking.security_group.id}"]
  vpc_id                    = module.networking.vpc_id
#  public-subnets            = ["${module.networking.public_subnet[0].id}","${module.networking.public_subnet[1].id}","${module.networking.public_subnet[2].id}"]
  public-subnets            = ["${module.networking.public_subnet[0].id}","${module.networking.public_subnet[1].id}"]
  app-instances             = module.ec2.app-instances
  praefect-instances        = module.ec2.praefect-instances
  mon-instances             = module.ec2.mon-instances
  domain                    = "sandbox783.opentlc.com"
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
  app_instances_ip          = module.ec2.app-1-private-dns
  gitaly_instances_ip       = module.ec2.gitaly-1-private-dns
  praefect_instances_ip     = module.ec2.praefect-1-private-dns
  mon_instances_ip          = module.ec2.mon-1-private-dns
  gitlab_lb_url             = module.lb.application_elb
  gitlab_version            = "14.0.5"
  praefect_internal_token   = "BFGSn2jdHtCvbacG"
  praefect_external_token   = "YDjg8YRpQnQeTEBm"
  gitlab_root_password      = "Compaq1!"
  grafana_admin_password    = "Compaq1!"
  praefect_database_endpoint  = module.rds.praefect_database_endpoint
  praefect_db_username      = "praefect"
  praefect_db_password      = module.rds.praefect_database_password
  praefect_db_name          = "praefect"
  gitlab_gui                = module.route53.gitlab-gui
  gitlab_pages              = module.route53.gitlab-pages
  gitlab_registry           = module.route53.gitlab-registry
  gitlab_region             = var.region
  gitlab_database_endpoint  = module.rds.gitlab_database_endpoint
  gitlab_db_name            = "gitlabpg"
  gitlab_db_username        = "gitlab"
  gitlab_db_password        = module.rds.gitlab_database_password
  elasticache_endpoint      = module.elasticache.elasticache_endpoint
  s3_registry               = module.s3.s3-registry
  s3_backup                 = module.s3.s3-backup
  s3_artifacts              = module.s3.s3-artifacts
  s3_uploads                = module.s3.s3-uploads
  s3_diffs                  = module.s3.s3-diffs
  s3_lfs                    = module.s3.s3-lfs
  monitoring_elb            = module.lb.monitoring_elb
  praefect_lb_url           = module.lb.storage_elb
}
