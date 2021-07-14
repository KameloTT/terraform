data "aws_region" "current" {}

data "aws_availability_zones" "current" {
  all_availability_zones = true
  filter {
    name   = "zone-name"
    values = ["${data.aws_region.current.name}a", "${data.aws_region.current.name}b", "${data.aws_region.current.name}c"]
  }
}

data "aws_caller_identity" "current" {}

resource "aws_elasticache_subnet_group" "default" {
  name       = "gitlab"
  subnet_ids = [aws_subnet.subnet-mgmt-1a.id,aws_subnet.subnet-mgmt-1b.id]
  tags = {}
}

resource "aws_elasticache_replication_group" "gitlab" {
  automatic_failover_enabled    = false
  availability_zones            = slice(data.aws_availability_zones.current.names, 0, 1)
  replication_group_id          = "gitlab"
  replication_group_description = "Redis cluster for Gitlab cluster"
  node_type                     = "cache.t3.medium"
  number_cache_clusters         = 1
  engine                        = "redis"
  engine_version                = "5.0.6"
  parameter_group_name          = "default.redis5.0"
  port                          = 6379
  subnet_group_name             = aws_elasticache_subnet_group.default.name
  security_group_ids            = [aws_security_group.ingress-all.id]
  at_rest_encryption_enabled    = true
  transit_encryption_enabled    = true
  tags = {}
}
