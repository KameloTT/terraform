provider "google" {
  credentials = file("./creds/gcp.json")
  project     = var.project_id
  region      = var.region
}

provider "google-beta" {
  credentials = file("./creds/gcp.json")
  project     = var.project_id
  region      = var.region
}
