resource "aws_instance" "gitaly-1" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all.id}"]
  subnet_id = "${aws_subnet.subnet-mgmt-1a.id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "gitaly-2" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all.id}"]
  subnet_id = "${aws_subnet.subnet-mgmt-1a.id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "praefect-1" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all.id}"]
  subnet_id = "${aws_subnet.subnet-mgmt-1a.id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "app-1" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all.id}"]
  subnet_id = "${aws_subnet.subnet-mgmt-1a.id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "app-1" {
  instance = "${aws_instance.app-1.id}"
  vpc      = true
}

resource "aws_instance" "pg-1" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all.id}"]
  subnet_id = "${aws_subnet.subnet-mgmt-1a.id}"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_instance" "mon-1" {
  ami = var.ami_id
  instance_type = "t3.medium"
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${aws_security_group.ingress-all.id}"]
  subnet_id = "${aws_subnet.subnet-mgmt-1a.id}"
  lifecycle {
    create_before_destroy = true
  }
}

