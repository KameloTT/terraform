resource "aws_instance" "gitlab-1" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all.id}"]
  subnet_id = "${aws_subnet.subnet-mgmt-1a.id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "gitlab-1" {
  instance = "${aws_instance.gitlab-1.id}"
  vpc      = true
}

output "gitlab-1-eip" {
  value = "${aws_eip.gitlab-1.public_dns}"
}
