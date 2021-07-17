resource "aws_route53_zone" "gitlab" {
  name = "gitlab.${var.lab-dns-zone}"
}

#resource "aws_route53_record" "gitlab-ns" {
#  zone_id = var.rh-zoneid
#  name    = aws_route53_zone.gitlab.name
#  type    = "NS"
#  ttl     = "300"
#  records = aws_route53_zone.gitlab.name_servers
#}

resource "aws_route53_record" "gui" {
  zone_id = aws_route53_zone.gitlab.zone_id
  name    = "gui"
  type    = "A"

  alias {
    name                   = var.app-dns-name
    zone_id                = var.app-zone-id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "pages" {
  zone_id = aws_route53_zone.gitlab.zone_id
  name    = "pages"
  type    = "A"

  alias {
    name                   = var.app-dns-name
    zone_id                = var.app-zone-id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "registry" {
  zone_id = aws_route53_zone.gitlab.zone_id
  name    = "registry"
  type    = "A"

  alias {
    name                   = var.app-dns-name
    zone_id                = var.app-zone-id
    evaluate_target_health = true
  }
}
