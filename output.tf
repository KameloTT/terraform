output "app-1-public-dns" {
  value = "${module.ec2.app-1-public-dns}"
}

output "gitaly-1-private-dns" {
  value = "${module.ec2.gitaly-1-private-dns}"
}
