resource "local_file" "sa_secret" {
  content = base64decode(google_service_account_key.gitlab-key.private_key)
  filename        = "./outputs/sa.json"
  file_permission = "0666"
}


resource "local_file" "rails" {
  content = yamlencode({
    "provider" : "Google"
    "google_project" : var.project_id
    "google_json_key_string" : base64decode(google_service_account_key.gitlab-key.private_key)
  })
  filename        = "./outputs/rails.yaml"
  file_permission = "0666"
}

resource "local_file" "gitlab_helm" {
  content = <<-EOT
    --set global.hosts.domain=example.com
    --set global.hosts.hostSuffix=dev
    --set global.hosts.https=false
    --set global.hosts.domain=${var.root_domain}
    --set global.hosts.externalIP=${google_compute_address.gitlab_ip.address}

    --set global.hosts.gitlab.name=gitlab.${var.root_domain}
    --set global.hosts.gitlab.https=false
    --set global.hosts.registry.name=registry.${var.root_domain}
    --set global.hosts.registry.https=false
    --set global.hosts.pages.name=pages.${var.root_domain}
    --set global.hosts.pages.https=false

    --set certmanager-issuer.email=${var.self_sign_email}

    --set postgresql.install=false
    --set global.psql.host=${google_dns_record_set.postgres.name}
    --set global.psql.password.secret=gitlab-postgresql-secret
    --set global.psql.password.key=postgresql-password

    --set redis.install=false
    --set global.redis.host=${google_dns_record_set.postgres.name}
    --set global.redis.password.secret=gitlab-redis-secret
    --set global.redis.password.key=redis-password

    --set global.minio.enabled=false

    --set global.registry.bucket=${google_storage_bucket.gitlab-registry-storage.name}
    --set registry.storage.secret=registry-storage
    --set registry.storage.key=config
    --set registry.storage.extraKey=gcs.json

    --set global.appConfig.lfs.bucket=${google_storage_bucket.gitlab-lfs-storage.name}
    --set global.appConfig.lfs.connection.secret=gitlab-rails-storage
    --set global.appConfig.lfs.connection.key=connection

    --set global.appConfig.artifacts.bucket=${google_storage_bucket.gitlab-artifacts-storage.name}
    --set global.appConfig.artifacts.connection.secret=gitlab-rails-storage
    --set global.appConfig.artifacts.connection.key=connection

    --set global.appConfig.uploads.bucket=${google_storage_bucket.gitlab-uploads-storage.name}
    --set global.appConfig.uploads.connection.secret=gitlab-rails-storage
    --set global.appConfig.uploads.connection.key=connection

    --set global.appConfig.packages.bucket=${google_storage_bucket.gitlab-packages-storage.name}
    --set global.appConfig.packages.connection.secret=gitlab-rails-storage
    --set global.appConfig.packages.connection.key=connection

    --set global.appConfig.externalDiffs.bucket=${google_storage_bucket.gitlab-externaldiffs-storage.name}
    --set global.appConfig.externalDiffs.connection.secret=gitlab-rails-storage
    --set global.appConfig.externalDiffs.connection.key=connection

    --set global.appConfig.ldap.preventSignin=true

    --set global.appConfig.backups.bucket=${google_storage_bucket.gitlab-backup-storage.name}
    --set global.appConfig.backups.tmpBucket=${google_storage_bucket.gitlab-restore-storage.name}
    --set gitlab.toolbox.backups.objectStorage.backend=gcs
    --set gitlab.toolbox.backups.objectStorage.config.gcpProject=${var.project_id}
    --set gitlab.toolbox.backups.objectStorage.config.secret=backup-storage-config
    --set gitlab.toolbox.backups.objectStorage.config.key=config
    --set gitlab.toolbox.persistence.enabled=true
    --set gitlab.toolbox.backups.cron.persistence.enabled=true

  EOT
  filename        = "./outputs/gitlab-helm.cfg"
  file_permission = "0666"
}
