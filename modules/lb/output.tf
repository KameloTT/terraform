output "storage_elb" {
  value = aws_elb.gitlab-storage-internal.dns_name
}

#output "application_elb" {
#  value = module.gitlab-nlb-public.this_lb_dns_name
#}

output "application_elb" {
  value = aws_elb.gitlab-nlb-public.dns_name
}

output "monitoring_elb" {
  value = aws_elb.gitlab-monitoring-internal.dns_name
}

#output "application_name" {
#  value = module.gitlab-nlb-public.target_group_names[0]
#}

#output "application_zone_id" {
#  value = module.gitlab-nlb-public.this_lb_zone_id
#}
output "application_zone_id" {
  value = aws_elb.gitlab-nlb-public.zone_id
}

output "storage_zone_id" {
  value = aws_elb.gitlab-storage-internal.zone_id
}

output "mon_zone_id" {
  value = aws_elb.gitlab-monitoring-internal.zone_id
}
