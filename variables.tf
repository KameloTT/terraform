variable "project_id" {
  description = "project id"
  default = "project-gitlab-343015"
}

variable "region" {
  description = "region"
  default = "us-central1"
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
