output "vpc_id" {
#  value = "${aws_vpc.vpc.id}"
  value = module.vpc.vpc_id
}

output "public_subnet" {
#  value = "${aws_subnet.public_subnet}"
  value = module.vpc.public_subnets
}

output "private_subnet" {
#  value = "${aws_subnet.private_subnet}"
  value = module.vpc.private_subnets
}

output "security_group" {
  value = "${aws_security_group.default}"
}
