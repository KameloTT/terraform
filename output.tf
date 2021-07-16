output "app-1-public-dns" {
  value = "${module.ec2.app-1-public-dns}"
}

output "app-1-private-dns" {
  value = "${module.ec2.app-1-private-dns}"
}

output "gitaly-1-private-dns" {
  value = "${module.ec2.gitaly-1-private-dns}"
}

output "gitaly-2-private-dns" {
  value = "${module.ec2.gitaly-2-private-dns}"
}

output "praefect-1-private-dns" {
  value = "${module.ec2.praefect-1-private-dns}"
}

output "mon-1-private-dns" {
  value = "${module.ec2.mon-1-private-dns}"
}
