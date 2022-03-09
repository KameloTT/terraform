variable "project_id" {
  description = "project id"
  default = "project-gitlab-343015"
}

variable "region" {
  description = "region"
  default = "us-central1"
}

variable "gke_num_nodes" {
  default     = 1
  description = "number of gke nodes"
}

variable "gke_flavor" {
  default     = "e2-standard-2"
  description = "GKE flavor for nodes(2vCPU, 8GB RAM)"
}

variable "root_domain" {
  description = "Global Domain"
  default = "example.com"
}

variable "self_sign_email" {
  description = "Email for lets encrypt"
  default = "avishnia@redhat.com"
}

variable "pg_flavor" {
  description = "PG instance type"
  default = "db-f1-micro"
}

variable "pg_user" {
  description = "PG user"
  default = "gitlab"
}

variable "pg_password" {
  description = "PG user password"
  default = "password"
}

variable "redis_password" {
  description = "redis auth key"
  default = "febb5c94-4df9-4d80-bc33-4cbddc979c78"
}

variable "gcp_service_list" {
  description = "GCP services for enabling"
  default = [
    "cloudresourcemanager.googleapis.com",
    "compute.googleapis.com",
    "container.googleapis.com",
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "redis.googleapis.com"
  ]
}
