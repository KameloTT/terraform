output "kubernetes_ca_certificate" {
  value = base64decode(aws_eks_cluster.gitlab.certificate_authority[0].data)
}

#output "kubernetes_token" {
#  value = data.kubernetes_secret.gitlab_admin_token.data.token
#}

output "kubernetes_api_url" {
  value = aws_eks_cluster.gitlab.endpoint
}
