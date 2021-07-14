resource "aws_s3_bucket" "app" {
  bucket = "gitlab-app-vish"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "backup" {
  bucket = "gitlab-backup-vish"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "artifacts" {
  bucket = "gitlab-artifacts-vish"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "uploads" {
  bucket = "gitlab-uploads-vish"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "registry" {
  bucket = "gitlab-registry-vish"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "diffs" {
  bucket = "gitlab-diffs-vish"
  acl    = "public-read-write"
}

resource "aws_s3_bucket" "lfs" {
  bucket = "gitlab-lfs-vish"
  acl    = "public-read-write"
}
