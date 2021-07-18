resource "aws_instance" "gitaly-1" {
  count=2
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
  tags = {
   app = "gitlab"
   role = "gitaly"
  }
}
resource "aws_instance" "praefect-1" {
  count = 1
  ami = var.ami
  instance_type = var.praefect-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.praefect-private-subnet
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
  tags = {
   app = "gitlab"
   role = "praefect"
  }
}

resource "aws_instance" "mon-1" {
  count = 1
  ami = var.ami
  instance_type = var.mon-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.mon-private-subnet
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
  tags = {
   app = "gitlab"
   role = "monitoring"
  }
}

resource "aws_instance" "app-1" {
  count = 1
  ami = var.ami
  instance_type = var.app-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.app-private-subnet
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
  tags = {
   app = "gitlab"
   role = "application"
  }
}

resource "aws_instance" "bastion" {
  count = 1
  ami = var.ami
  instance_type = var.bastion-instance-type
  key_name = "${aws_key_pair.gitlab.key_name}"
  vpc_security_group_ids = var.vpc_security_group_ids
  subnet_id = var.bastion-public-subnet
  associate_public_ip_address = true
  lifecycle {
    create_before_destroy = true
  }
  disable_api_termination = false
  ebs_optimized = true
  root_block_device {
    volume_size = "20"
  }
  tags = {}
}
