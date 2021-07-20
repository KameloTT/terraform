resource "aws_db_subnet_group" "default" {
  name       = "gitlab"
  subnet_ids = var.private-subnets
}

module "rds" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "2.20"
  identifier            = "gitlab-db"
  engine                = "postgres"
  engine_version        = "13.1"
  instance_class        = var.instance-type
  allocated_storage     = 50
  storage_type          = "gp2"
  storage_encrypted     = true
  multi_az              = false
  publicly_accessible   = false
  copy_tags_to_snapshot = true
  name                  = var.gitlab-dbname
  username              = var.gitlab-username
  password              = var.gitlab-password
  port                  = "5432"

  replicate_source_db    = null
  vpc_security_group_ids = var.vpc_security_group_ids

  backup_retention_period = 0
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"

  db_subnet_group_name      = aws_db_subnet_group.default.name
  parameter_group_name      = "default.postgres13"
  create_db_parameter_group = false
  create_db_option_group    = false

  deletion_protection = false
  allow_major_version_upgrade = true
}

module "rds-storage" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "2.20"
  identifier            = "gitlab-storage"
  engine                = "postgres"
  engine_version        = "13.1"
  instance_class        = var.instance-type
  allocated_storage     = 50
  storage_type          = "gp2"
  storage_encrypted     = true
  multi_az              = true
  publicly_accessible   = false
  copy_tags_to_snapshot = true
  name                  = var.praefect-dbname
  username              = var.praefect-username
  password              = var.praefect-password
  port                  = "5432"

  vpc_security_group_ids = var.vpc_security_group_ids

  backup_retention_period = 0
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"

  db_subnet_group_name      = aws_db_subnet_group.default.name
  parameter_group_name      = "default.postgres13"
  create_db_parameter_group = false
  create_db_option_group    = false

  deletion_protection = false
  allow_major_version_upgrade = true
}
