output "gitlab-gui" {
  value = aws_route53_record.gui.fqdn
}

output "gitlab-pages" {
  value = aws_route53_record.pages.fqdn
}

output "gitlab-registry" {
  value = aws_route53_record.registry.fqdn
}
