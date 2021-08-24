#output "primary_kubernetes_ca_certificate" {
#  value = base64decode(aws_eks_cluster.pwx-primary.certificate_authority[0].data)
#}

#output "primary_kubernetes_token" {
#  value = data.kubernetes_secret.gitlab_admin_token.data.token
#}

#output "primary_kubernetes_api_url" {
#  value = aws_eks_cluster.pwx-primary.endpoint
#}
