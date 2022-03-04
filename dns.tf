resource "google_dns_managed_zone" "gitlab" {
  name     = "gitlab-zone"
  dns_name = "example.com."
  visibility = "private"
}

resource "google_dns_record_set" "frontend" {
  name = "gitlab.${google_dns_managed_zone.gitlab.dns_name}"
  type = "A"
  ttl  = 300

  managed_zone = google_dns_managed_zone.gitlab.name

  rrdatas = [google_compute_address.gitlab_ip.address]
}
