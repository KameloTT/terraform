output "storage_elb" {
  value = aws_elb.gitlab-storage-internal.dns_name
}

output "application_elb" {
  value = module.gitlab-nlb-public.this_lb_dns_name
}

output "monitoring_elb" {
  value = aws_elb.gitlab-monitoring-internal.dns_name
}

output "application_name" {
  value = module.gitlab-nlb-public.target_group_names[0]
}
