resource "google_compute_global_address" "pg-address" {
  provider = google-beta

  name          = "pg-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.vpc.id
}

#resource "google_service_networking_connection" "private_vpc_connection" {
#  provider = google-beta
#
#  network                 = google_compute_network.vpc.id
#  service                 = "servicenetworking.googleapis.com"
#  reserved_peering_ranges = [google_compute_global_address.pg-address.name]
#}

resource "random_id" "pg_name_suffix" {
  byte_length = 4
}

resource "google_sql_database_instance" "gitlab" {
  provider = google-beta
  name             = "pg-instance-${random_id.pg_name_suffix.hex}"
  region           = var.region
  database_version = "POSTGRES_13"

  deletion_protection=false

  depends_on = [google_service_networking_connection.private_vpc_connection]

  settings {
    tier = "${var.pg_flavor}"
    ip_configuration {
      ipv4_enabled    = false
      private_network = google_compute_network.vpc.id
      authorized_networks {
        name = "Gitlab GKE Cluster"
        value = google_container_cluster.primary.endpoint 
      }
    }
  }
}

resource "google_sql_user" "users" {
  name     = var.pg_user
  instance = google_sql_database_instance.gitlab.name
  password = var.pg_password
}

resource "google_sql_database" "database" {
  name      = "gitlabhq_production"
  instance  = "${google_sql_database_instance.gitlab.name}"
}
