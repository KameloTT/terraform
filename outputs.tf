output "region" {
  value       = var.region
  description = "GCloud Region"
}

output "project_id" {
  value       = var.project_id
  description = "GCloud Project ID"
}

#output "kubernetes_cluster_name" {
#  value       = google_container_cluster.primary.name
#  description = "GKE Cluster Name"
#}

#output "kubernetes_cluster_host" {
#  value       = google_container_cluster.primary.endpoint
#  description = "GKE Cluster Host"
#}

output "gitlab_ip" {
  value = google_compute_address.gitlab_ip.address
  description = "External IP for GitLab"
}

output "pg_ip" {
  value = google_compute_global_address.pg-address.address
  description = "PG IP"
}


