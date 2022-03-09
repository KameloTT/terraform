resource "google_compute_global_address" "redis_range" {
  name          = "redis-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

#resource "google_service_networking_connection" "redis_private_service_connection" {
#  network                 = google_compute_network.vpc.id
#  service                 = "servicenetworking.googleapis.com"
#  reserved_peering_ranges = [google_compute_global_address.redis_range.name]
#}

resource "google_redis_instance" "cache" {
  name           = "private-cache"
  tier           = "STANDARD_HA"
  memory_size_gb = 1

  authorized_network = google_compute_network.vpc.id
  connect_mode       = "PRIVATE_SERVICE_ACCESS"

  redis_version     = "REDIS_4_0"
  display_name      = "Terraform gitlab Instance"

  depends_on = [google_service_networking_connection.private_vpc_connection]

  auth_enabled = true
}
