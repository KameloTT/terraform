resource "google_compute_address" "gitlab_ip" {
  name = "ipv4-address"
  address_type = "EXTERNAL"
}
