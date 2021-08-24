output "bastion-public-dns" {
  value = aws_instance.bastion.*.public_dns
}

output "sshkey" {
  value = aws_key_pair.pwx.key_name
}
