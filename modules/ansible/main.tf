resource "local_file" "ansible_hosts" {
  content = templatefile("${path.module}/templates/hosts.js",
    {
     app-instances = var.app-instances-ip
     gitaly-instances = var.gitaly-instances-ip
     praefect-instances = var.praefect-instances-ip
     mon-instances = var.mon-instances-ip
    }
  )
  filename = "ansible/hosts"
}
resource "local_file" "ansible_vars" {
  content = yamlencode({
    "gitlab_version"             : var.gitlab_version
    "praefect_internal_token"    : var.praefect_internal_token
    "praefect_external_token"    : var.praefect_external_token
    "gitlab_root_password"       : var.gitlab_root_password
    "grafana_admin_password"     : var.grafana_admin_password
    "gitlab-lb-url"              : var.gitlab-lb-url
    "praefect_database-endpoint" : var.praefect-database-endpoint
    "praefect-db-username"       : var.praefect-db-username
    "praefect-db-password"       : var.praefect-db-password
    "praefect-db-name"           : var.praefect-db-name
    "gitlab-gui"                 : var.gitlab-gui
    "gitlab-pages"               : var.gitlab-pages
    "gitlab-registry"            : var.gitlab-registry
    "gitlab-region"              : var.gitlab-region
    "gitlab-database-endpoint"   : var.gitlab-database-endpoint
    "gitlab-db-name"             : var.gitlab-db-name
    "gitlab-db-username"         : var.gitlab-db-username
    "gitlab-db-password"         : var.gitlab-db-password
    "elasticache_endpoint"       : var.elasticache_endpoint
    "s3-registry"                : var.s3-registry
    "s3-backup"                  : var.s3-backup
    "s3-artifacts"               : var.s3-artifacts
    "s3-uploads"                 : var.s3-uploads
    "s3-diffs"                   : var.s3-diffs
    "s3-lfs"                     : var.s3-lfs
    "monitoring_elb"             : var.monitoring_elb
    "praefect-lb-url"            : var.praefect-lb-url
  })
  filename        = "${path.module}/../../ansible/group_vars/all"
  file_permission = "0666"
}
#resource "local_file" "ansible_gitaly" {
#  content = templatefile("${path.module}/templates/gitaly.rb.j2",{
#    gitlab-lb-public = var.lb-public-url
#  })
#  filename = "ansible/templates/gitaly.rb.j2"
#}

#resource "local_file" "ansible_praefect" {
#  content = templatefile("templates/praefect.rb.j2",{
#    db_ip = module.rds-storage.this_db_instance_address,
#    praefect_sql_user = module.rds-storage.this_db_instance_username,
#    praefect_sql_password = module.rds-storage.this_db_instance_password,
#    praefect_database = module.rds-storage.this_db_instance_name,
#    gitaly-1 = aws_instance.gitaly-1.private_dns,
#    gitaly-2 = aws_instance.gitaly-2.private_dns
#})
#  filename = "ansible/templates/praefect.rb.j2"
#}

#resource "local_file" "ansible_application" {
#  content = templatefile("templates/application.rb.j2",{
#    app-1-public = aws_instance.app-1.public_dns,
#    db_ip = module.rds.this_db_instance_address,
#    db_user = module.rds.this_db_instance_username,
#    db_password = module.rds.this_db_instance_password,
#    db_name = module.rds.this_db_instance_name,
#    region = data.aws_region.current.name,
#    redis_ip = aws_elasticache_replication_group.gitlab.primary_endpoint_address,
#    bucket-app = aws_s3_bucket.app.bucket,
#    mon-1-public = aws_instance.mon-1.public_dns,
#    praefect-1-private = aws_instance.praefect-1.private_dns,
#    bucket-backup = aws_s3_bucket.backup.bucket,
#    bucket-artifacts = aws_s3_bucket.artifacts.bucket,
#    bucket-uploads = aws_s3_bucket.uploads.bucket,
#    bucket-registry = aws_s3_bucket.registry.bucket,
#    bucket-diffs = aws_s3_bucket.diffs.bucket,
#    bucket-lfs = aws_s3_bucket.lfs.bucket
#})
#  filename = "ansible/templates/application.rb.j2"
#}
