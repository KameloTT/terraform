resource "aws_elasticache_subnet_group" "default" {
  name       = "gitlab"
  subnet_ids = var.private-subnets
  tags = {}
}

resource "aws_elasticache_replication_group" "gitlab" {
  automatic_failover_enabled    = false
  availability_zones            = var.availability_zones
  replication_group_id          = "gitlab"
  replication_group_description = "Redis cluster for Gitlab cluster"
  node_type                     = var.instance-type
  number_cache_clusters         = 1
  engine                        = "redis"
  engine_version                = "5.0.6"
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.default.name
  security_group_ids            = var.vpc_security_group_ids
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  tags = {}
}
