output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

output "kubernetes_cluster_name" {
  value       = google_container_cluster.primary.name
  description = "GKE Cluster Name"
}

output "kubernetes_cluster_host" {
  value       = google_container_cluster.primary.endpoint
  description = "GKE Cluster Host"
}

output "gitlab_ip" {
  value = google_compute_address.gitlab_ip.address
  description = "External IP for GitLab"
}

output "pg_ip" {
  value = google_sql_database_instance.gitlab.private_ip_address
  description = "PG IP"
}

output "redis_ip" {
  value = google_redis_instance.cache.host
  description = "Redis IP"
}

output "redis_dns" {
  value = google_dns_record_set.redis.name
  description = "Redis DNS"
}

output "postgres_dns" {
  value = google_dns_record_set.postgres.name
  description = "Postgres DNS"
}

output "gitlab_dns" {
  value = google_dns_record_set.gitlab.name
  description = "Gitlab DNS"
}

output "redis_auth" {
  value = google_redis_instance.cache.auth_string
  description = "Redis Auth string"
}
