resource "aws_elb" "gitlab-storage-internal" {
  name                      = "gitlab-storage-internal"
  internal                  = true
  subnets                   = var.private-subnets
  cross_zone_load_balancing = true
  connection_draining       = true
  security_groups           = var.vpc_security_group_ids
  instances                 = var.praefect-instances

  listener {
    instance_port     = 2305
    instance_protocol = "TCP"
    lb_port           = 2305
    lb_protocol       = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:2305"
    interval            = 30
  }

  tags = {
    Name = "gitlab-storage-internal"
    app  = "gitlab"
  }
}

module "gitlab-nlb-public" {
  source             = "terraform-aws-modules/alb/aws"
  version            = "5.15"
  name               = "gitlab-nlb-public"
  load_balancer_type = "network"
  vpc_id             = var.vpc_id
  subnets            = var.public-subnets

  target_groups = [
    {
      name_prefix      = "ssh-"
      backend_protocol = "TCP"
      backend_port     = 22
      target_type      = "instance"
      health_check = {
        port     = 22
        protocol = "TCP"
      }
    },
    {
      name_prefix      = "http-"
      backend_protocol = "TCP"
      backend_port     = 80
      target_type      = "instance"
      health_check = {
        port     = 80
        protocol = "HTTP"
        path     = "/-/health"
      }
    },
    {
      name_prefix      = "https-"
      backend_protocol = "TCP"
      backend_port     = 443
      target_type      = "instance"
      health_check = {
        port     = 80
        protocol = "HTTP"
        path     = "/-/health"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 22
      protocol           = "TCP"
      target_group_index = 0
    },
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 1
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 2
    }
  ]

  tags = {
    Name = "gitlab-nlb-public"
    app  = "gitlab"
  }
}

resource "aws_elb" "gitlab-monitoring-internal" {
  name                      = "gitlab-monitoring"
  internal                  = true
  subnets                   = var.private-subnets
  security_groups           = var.vpc_security_group_ids
  cross_zone_load_balancing = true
  connection_draining       = true

  listener {
    instance_port     = 9090
    instance_protocol = "TCP"
    lb_port           = 9090
    lb_protocol       = "TCP"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:9090"
    interval            = 30
  }

  tags = {
    Name = "gitlab-monitoring-internal"
    app  = "gitlab"
  }
}

resource "aws_lb_target_group_attachment" "public-22" {
  count            = "${length(var.app-instances)}"
  target_group_arn = module.gitlab-nlb-public.target_group_arns[0]
  target_id        = var.app-instances[count.index]
  port             = 22
}

resource "aws_lb_target_group_attachment" "public-80" {
  count            = "${length(var.app-instances)}"
  target_group_arn = module.gitlab-nlb-public.target_group_arns[1]
  target_id        = var.app-instances[count.index]
  port             = 80
}

resource "aws_lb_target_group_attachment" "public-443" {
  count            = "${length(var.app-instances)}"
  target_group_arn = module.gitlab-nlb-public.target_group_arns[1]
  target_id        = var.app-instances[count.index]
  port             = 443
}

