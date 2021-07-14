variable "ami_name" {
  type = list(string)
  default = ["CENTOS 8"]
}
variable "ami_id" {
  default = "ami-059f1cc52e6c85908"
}

provider "aws" {
  region = "us-east-1"
}
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
resource "aws_security_group" "ingress-all" {
  name = "allow-all-sg"
  vpc_id = "${aws_vpc.gitlab-infra.id}"
  ingress {
    description = "SSH"
    cidr_blocks = ["0.0.0.0/0"]
    from_port = 22
    to_port = 22
    protocol = "tcp"
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ANY"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "subnet-mgmt-1a" {
  cidr_block = "${cidrsubnet(aws_vpc.gitlab-infra.cidr_block, 3, 1)}"
  vpc_id = "${aws_vpc.gitlab-infra.id}"
  availability_zone = "us-east-1a"
}

resource "aws_subnet" "subnet-mgmt-1b" {
  cidr_block = "${cidrsubnet(aws_vpc.gitlab-infra.cidr_block, 4, 1)}"
  vpc_id = "${aws_vpc.gitlab-infra.id}"
  availability_zone = "us-east-1b"
}

resource "aws_internet_gateway" "gitlab-gw" {
  vpc_id = "${aws_vpc.gitlab-infra.id}"
}

resource "aws_route_table" "gitlab-route-table" {
  vpc_id = "${aws_vpc.gitlab-infra.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gitlab-gw.id}"
  }
}
resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-mgmt-1a.id}"
  route_table_id = "${aws_route_table.gitlab-route-table.id}"
}

