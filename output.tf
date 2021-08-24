output "bastion-public-dns" {
  value = module.ec2.bastion-public-dns[0]
}


#output "primary_eks_cert" {
#  value = module.eks.primary_kubernetes_ca_certificate
#  sensitive = true
#}

#output "eks-token" {
#  value = module.eks.kubernetes_token
#  sensitive = true
#}

#output "primary_eks_url" {
#  value = module.eks.primary_kubernetes_api_url
#}
