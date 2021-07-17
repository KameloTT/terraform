output "elasticache_endpoint" {
  value = aws_elasticache_replication_group.gitlab.primary_endpoint_address
}
