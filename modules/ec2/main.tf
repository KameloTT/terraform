resource "aws_instance" "bastion" {
  count = 1
  ami = var.ami
  instance_type = var.bastion-instance-type
  key_name = "${aws_key_pair.pwx.key_name}"
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
