output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "public_subnet" {
  value = "${aws_subnet.public_subnet}"
}

output "private_subnet" {
  value = "${aws_subnet.private_subnet}"
}

output "security_group" {
  value = "${aws_security_group.default}"
}
