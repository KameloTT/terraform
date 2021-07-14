resource "aws_db_subnet_group" "default" {
  name       = "gitlab"
  subnet_ids = [aws_subnet.subnet-mgmt-1a.id,aws_subnet.subnet-mgmt-1b.id]
}

module "rds" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "2.20"
  identifier            = "gitlab-db"
  engine                = "postgres"
  engine_version        = "11.10"
  instance_class        = "db.t3.medium"
  allocated_storage     = 50
  storage_type          = "gp2"
  storage_encrypted     = true
  multi_az              = false
  publicly_accessible   = false
  copy_tags_to_snapshot = true
  name                  = "gitlabpg"
  username              = "gitlab"
  password              = "compaq123"
  port                  = "5432"

  replicate_source_db    = null
  vpc_security_group_ids = [aws_security_group.ingress-all.id]

  backup_retention_period = 0
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"

  db_subnet_group_name      = aws_db_subnet_group.default.name
  parameter_group_name      = "default.postgres11"
  create_db_parameter_group = false
  create_db_option_group    = false

  deletion_protection = false
}

module "rds-storage" {
  source                = "terraform-aws-modules/rds/aws"
  version               = "2.20"
  identifier            = "gitlab-storage"
  engine                = "postgres"
  engine_version        = "11.10"
  instance_class        = "db.t3.medium"
  allocated_storage     = 50
  storage_type          = "gp2"
  storage_encrypted     = true
  multi_az              = true
  publicly_accessible   = false
  copy_tags_to_snapshot = true
  name                  = "praefect"
  username              = "praefect"
  password              = "compaq123"
  port                  = "5432"

  vpc_security_group_ids = [aws_security_group.ingress-all.id]

  backup_retention_period = 0
  maintenance_window      = "Mon:00:00-Mon:03:00"
  backup_window           = "03:00-06:00"

  db_subnet_group_name      = aws_db_subnet_group.default.name
  parameter_group_name      = "default.postgres11"
  create_db_parameter_group = false
  create_db_option_group    = false

  deletion_protection = false
}
