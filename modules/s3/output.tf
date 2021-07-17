output "s3-uploads" {
  value = aws_s3_bucket.uploads.bucket
}

output "s3-registry" {
  value = aws_s3_bucket.registry.bucket
}

output "s3-lfs" {
  value = aws_s3_bucket.lfs.bucket
}

output "s3-diffs" {
  value = aws_s3_bucket.diffs.bucket
}

output "s3-backup" {
  value = aws_s3_bucket.backup.bucket
}

output "s3-artifacts" {
  value = aws_s3_bucket.artifacts.bucket
}

output "s3-app" {
  value = aws_s3_bucket.app.bucket
}
