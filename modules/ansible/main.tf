resource "local_file" "ansible_hosts" {
  content = templatefile("${path.module}/templates/hosts.js",
    {
     bastion_instance = var.bastion_instance_ip
     app_instances = var.app_instances_ip
     gitaly_instances = var.gitaly_instances_ip
     praefect_instances = var.praefect_instances_ip
     mon_instances = var.mon_instances_ip
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
    "gitlab_lb_url"              : var.gitlab_lb_url
    "praefect_database_endpoint" : var.praefect_database_endpoint
    "praefect_db_username"       : var.praefect_db_username
    "praefect_db_password"       : var.praefect_db_password
    "praefect_db_name"           : var.praefect_db_name
    "gitlab_gui"                 : var.gitlab_gui
    "gitlab_pages"               : var.gitlab_pages
    "gitlab_registry"            : var.gitlab_registry
    "gitlab_region"              : var.gitlab_region
    "gitlab_database_endpoint"   : var.gitlab_database_endpoint
    "gitlab_db_name"             : var.gitlab_db_name
    "gitlab_db_username"         : var.gitlab_db_username
    "gitlab_db_password"         : var.gitlab_db_password
    "elasticache_endpoint"       : var.elasticache_endpoint
    "s3_registry"                : var.s3_registry
    "s3_backup"                  : var.s3_backup
    "s3_artifacts"               : var.s3_artifacts
    "s3_uploads"                 : var.s3_uploads
    "s3_diffs"                   : var.s3_diffs
    "s3_lfs"                     : var.s3_lfs
    "monitoring_elb"             : var.monitoring_elb
    "praefect_lb_url"            : var.praefect_lb_url
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
