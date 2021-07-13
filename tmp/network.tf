resource "aws_vpc" "gitlab-infra" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags = {
    Name = "gitlab-infra"
  }
}

resource "aws_key_pair" "gitlab" {
  key_name   = "gitlab"
  public_key = file("gitlab.pub")
}
