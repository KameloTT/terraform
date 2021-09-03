resource "aws_s3_bucket" "pwx" {
  bucket = "pwx-backup-vish"
  acl    = "public-read-write"
}
