resource "aws_instance" "gitaly-1" {
  ami = var.ami
  instance_type = var.gitaly-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.gitaly-private-subnet
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
}
/*
resource "aws_instance" "gitaly-2" {
  ami = var.ami_id
  instance_type = var.gitaly-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${module.networking.aws_security_group.default.id}"]
  subnet_id = "${module.networking.aws_subnet.private_subnet[1].id}"
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
}

resource "aws_instance" "praefect-1" {
  ami = var.ami_id
  instance_type = var.praefect-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${module.networking.aws_security_group.default.id}"]
  subnet_id = "${module.networking.aws_subnet.private_subnet[0].id}"
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
}
resource "aws_instance" "mon-1" {
  ami = var.ami_id
  instance_type = var.mon-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = ["${module.networking.aws_security_group.default.id}"]
  subnet_id = "${module.networking.aws_subnet.private_subnet[0].id}"
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
}
*/

resource "aws_instance" "app-1" {
  ami = var.ami
  instance_type = var.app-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.app-public-subnet
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
}

#resource "aws_eip" "app-1" {
#  instance = "${aws_instance.app-1.id}"
#  vpc      = true
#}
