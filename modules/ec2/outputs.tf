output "bastion-public-dns" {
  value = aws_instance.bastion.*.public_dns
}

output "app-1-private-dns" {
  value = aws_instance.app-1.*.private_dns
}

output "gitaly-1-private-dns" {
 value = aws_instance.gitaly-1.*.private_dns
}

output "praefect-1-private-dns" {
 value = aws_instance.praefect-1.*.private_dns
}

output "mon-1-private-dns" {
 value = aws_instance.mon-1.*.private_dns
}

output "bastion-instances" {
  value = aws_instance.bastion.*.id
}

output "app-instances" {
  value = aws_instance.app-1.*.id
}

output "gitaly-instances" {
  value = aws_instance.gitaly-1.*.id
}

output "praefect-instances" {
  value = aws_instance.praefect-1.*.id
}

output "mon-instances" {
  value = aws_instance.mon-1.*.id
}
