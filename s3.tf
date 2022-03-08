resource "google_service_account" "sa_gitlab_storage" {
  account_id   = "gitlab-storage-id"
  display_name = "Gitlab Storage Service Account"
}

resource "google_service_account_key" "gitlab-key" {
  service_account_id = google_service_account.sa_gitlab_storage.name
  public_key_type    = "TYPE_X509_PEM_FILE"
}

#Registry Storage
resource "google_storage_bucket" "gitlab-registry-storage" {
  name          = "gitlab-registry-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "registry-binding" {
  bucket = google_storage_bucket.gitlab-registry-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Large FS Storage
resource "google_storage_bucket" "gitlab-lfs-storage" {
  name          = "gitlab-lfs-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "lfs-binding" {
  bucket = google_storage_bucket.gitlab-lfs-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Artifacts Storage
resource "google_storage_bucket" "gitlab-artifacts-storage" {
  name          = "gitlab-artifacts-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "artifacts-binding" {
  bucket = google_storage_bucket.gitlab-artifacts-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Uploads Storage
resource "google_storage_bucket" "gitlab-uploads-storage" {
  name          = "gitlab-uploads-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "uploads-binding" {
  bucket = google_storage_bucket.gitlab-uploads-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Packages Storage
resource "google_storage_bucket" "gitlab-packages-storage" {
  name          = "gitlab-packages-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "packages-binding" {
  bucket = google_storage_bucket.gitlab-packages-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Diffs Storage
resource "google_storage_bucket" "gitlab-externaldiffs-storage" {
  name          = "gitlab-externaldiffs-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "externaldiffs-binding" {
  bucket = google_storage_bucket.gitlab-externaldiffs-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Backup Storage
resource "google_storage_bucket" "gitlab-backup-storage" {
  name          = "gitlab-backup-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "backup-binding" {
  bucket = google_storage_bucket.gitlab-backup-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Restore Storage
resource "google_storage_bucket" "gitlab-restore-storage" {
  name          = "gitlab-restore-bucket-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "restore-binding" {
  bucket = google_storage_bucket.gitlab-restore-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}

#Pages Storage
resource "google_storage_bucket" "gitlab-pages-storage" {
  name          = "gitlab-diff-pages-vish"
  location      = "us-central1"
  force_destroy = true
}

resource "google_storage_bucket_iam_binding" "pages-binding" {
  bucket = google_storage_bucket.gitlab-pages-storage.name
  role = "roles/storage.admin"
  members = [
    "serviceAccount:${google_service_account.sa_gitlab_storage.email}",
  ]
}
