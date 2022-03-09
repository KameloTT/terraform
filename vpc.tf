# VPC
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  auto_create_subnetworks = "false"
}

# Subnet
resource "google_compute_subnetwork" "subnet" {
  name          = "${var.project_id}-subnet"
  region        = var.region
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
  private_ip_google_access = true
}

resource "google_service_networking_connection" "private_vpc_connection" {
  provider = google-beta
  network                 = google_compute_network.vpc.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.pg-address.name,google_compute_global_address.redis_range.name]
}

resource "google_compute_network_peering_routes_config" "private_service_access_generic" {

  provider = google-beta
  depends_on = [google_service_networking_connection.private_vpc_connection]
  peering = "servicenetworking-googleapis-com" # Hardcoded name
  network = google_compute_network.vpc.name
  import_custom_routes = false
  export_custom_routes = true # We change this from the default to export our custom routes
}
