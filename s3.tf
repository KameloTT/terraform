resource "google_service_account" "sa_gitlab_storage" {
  account_id   = "gitlab-storage-id"
  display_name = "Gitlab Storage Service Account"
}

resource "google_storage_bucket" "auto-expire" {
  name          = "auto-expiring-bucket"
  location      = "US"
  force_destroy = true
}

data "google_iam_policy" "gitlab-storage-admin" {
  binding {
    role = "roles/storage.admin"
    members = [
      google_service_account.sa_gitlab_storage.email,
    ]
  }
}

resource "google_storage_bucket_iam_policy" "policy" {
  bucket = google_storage_bucket.default.name
  policy_data = data.google_iam_policy.admin.policy_data
}
