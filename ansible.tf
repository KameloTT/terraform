resource "local_file" "ansible_vars" {
  content = <<-EOT
  [app]
  ${aws_eip.app-1.public_dns}
  [gitaly]
  ${aws_instance.gitaly-1.private_ip}
  [praefect]
  ${aws_instance.praefect-1.private_ip}
  [mon]
  ${aws_instance.mon-1.private_ip}
  EOT
  filename = "ansible/hosts"
}

resource "local_file" "ansible_gitaly" {
  content = templatefile("templates/gitaly.rb.j2",{
    gitaly-1 = aws_instance.gitaly-1.private_dns,
    gitaly-2 = aws_instance.gitaly-2.private_dns,
    app-1-public = aws_instance.app-1.public_dns
  })
  filename = "ansible/templates/gitaly.rb.j2"
}

resource "local_file" "ansible_praefect" {
  content = templatefile("templates/praefect.rb.j2",{
    db_ip = module.rds-storage.this_db_instance_address,
    praefect_sql_user = module.rds-storage.this_db_instance_username,
    praefect_sql_password = module.rds-storage.this_db_instance_password,
    praefect_database = module.rds-storage.this_db_instance_name,
    gitaly-1 = aws_instance.gitaly-1.private_dns,
    gitaly-2 = aws_instance.gitaly-2.private_dns
})
  filename = "ansible/templates/praefect.rb.j2"
}

resource "local_file" "ansible_application" {
  content = templatefile("templates/application.rb.j2",{
    app-1-public = aws_instance.app-1.public_dns,
    db_ip = module.rds.this_db_instance_address,
    db_user = module.rds.this_db_instance_username,
    db_password = module.rds.this_db_instance_password,
    db_name = module.rds.this_db_instance_name,
    region = data.aws_region.current.name,
    redis_ip = aws_elasticache_replication_group.gitlab.primary_endpoint_address,
    bucket-app = aws_s3_bucket.app.bucket,
    mon-1-public = aws_instance.mon-1.public_dns,
    praefect-1-private = aws_instance.praefect-1.private_dns,
    bucket-backup = aws_s3_bucket.backup.bucket,
    bucket-artifacts = aws_s3_bucket.artifacts.bucket,
    bucket-uploads = aws_s3_bucket.uploads.bucket,
    bucket-registry = aws_s3_bucket.registry.bucket,
    bucket-diffs = aws_s3_bucket.diffs.bucket,
    bucket-lfs = aws_s3_bucket.lfs.bucket
})
  filename = "ansible/templates/application.rb.j2"
}
