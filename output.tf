output "app-1-public-dns" {
  value = module.ec2.app-public-dns
}

output "app-1-private-dns" {
  value = module.ec2.app-1-private-dns
}

output "gitaly-1-private-dns" {
  value = module.ec2.gitaly-1-private-dns
}

output "praefect-1-private-dns" {
  value = module.ec2.praefect-1-private-dns
}

output "mon-1-private-dns" {
  value = module.ec2.mon-1-private-dns
}

output "gitlab_database_endpoint" {
  value = module.rds.gitlab_database_endpoint
}

output "gitlab_database_password" {
  value = module.rds.gitlab_database_password
  sensitive = true
}

output "storage_database_endpoint" {
  value = module.rds.storage_database_endpoint
}

output "storage_database_password" {
  value = module.rds.storage_database_password
  sensitive = true
}

output "elasticache_endpoint" {
  value = module.elasticache.elasticache_endpoint
}

output "eks-cert" {
  value = module.eks.kubernetes_ca_certificate
  sensitive = true
}

#output "eks-token" {
#  value = module.eks.kubernetes_token
#  sensitive = true
#}

output "eks-url" {
  value = module.eks.kubernetes_api_url
}

output "storage_elb" {
  value = module.lb.storage_elb
}

output "application_elb" {
  value = module.lb.application_elb
}

output "monitoring_elb" {
  value = module.lb.monitoring_elb
}
