output "gitaly-1-ip" {
  value = "${aws_instance.gitaly-1.private_ip}"
}

output "gitaly-2-ip" {
  value = "${aws_instance.gitaly-2.private_ip}"
}

output "praefect-1-ip" {
  value = "${aws_instance.praefect-1.private_ip}"
}

output "app-1-eip" {
  value = "${aws_eip.app-1.public_dns}"
}

output "pg-1-ip" {
  value = "${aws_instance.pg-1.private_ip}"
}

output "mon-1-ip" {
  value = "${aws_instance.mon-1.private_ip}"
}

output "kubernetes_ca_certificate" {
  value = base64decode(aws_eks_cluster.gitlab.certificate_authority[0].data)
  sensitive = true
}

output "kubernetes_token" {
  value = data.aws_eks_cluster_auth.gitlab.token
  sensitive = true
}

output "kubernetes_api_url" {
  value = aws_eks_cluster.gitlab.endpoint
}
