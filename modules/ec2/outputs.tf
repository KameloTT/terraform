output "app-1-public-dns" {
  value = "${aws_instance.app-1.public_dns}"
}

output "gitaly-1-private-dns" {
 value = "${aws_instance.gitaly-1.private_dns}"
}
