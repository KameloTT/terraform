resource "google_dns_managed_zone" "gitlab" {
  name     = "gitlab-zone"
  dns_name = "${root_domain}."
  visibility = "private"
}

resource "google_dns_record_set" "gitlab" {
  name = "gitlab.${google_dns_managed_zone.gitlab.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.gitlab.name

  rrdatas = [google_compute_address.gitlab_ip.address]
}

resource "google_dns_record_set" "gitlab-registry" {
  name = "registry.${google_dns_managed_zone.gitlab.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.gitlab.name

  rrdatas = [google_compute_address.gitlab_ip.address]
}

resource "google_dns_record_set" "pages" {
  name = "pages.${google_dns_managed_zone.gitlab.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.gitlab.name

  rrdatas = [google_compute_address.gitlab_ip.address]
}

resource "google_dns_record_set" "postgres" {
  name = "postgres.${google_dns_managed_zone.gitlab.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.gitlab.name

  rrdatas = [google_sql_database_instance.gitlab.private_ip_address]
}

resource "google_dns_record_set" "redis" {
  name = "redis.${google_dns_managed_zone.gitlab.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.gitlab.name

  rrdatas = [google_redis_instance.cache.host]
}
