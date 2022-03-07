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
    global.hosts.domain=example.com
    global.hosts.hostSuffix=dev
    global.hosts.https=false
    global.hosts.domain=${var.root_domain}
    global.hosts.externalIP=${google_compute_address.gitlab_ip.address}

    global.hosts.gitlab.name=gitlab.${google_dns_managed_zone.gitlab.dns_name}
    global.hosts.gitlab.https=false
    global.hosts.registry.name=registry.${google_dns_managed_zone.gitlab.dns_name}
    global.hosts.registry.https=false
    global.hosts.pages.name=pages.${google_dns_managed_zone.gitlab.dns_name}
    global.hosts.pages.https=false

    certmanager-issuer.email=${var.self_sign_email}

    postgresql.install=false
    global.psql.host=${google_dns_record_set.postgres.name}
    global.psql.password.secret=gitlab-postgresql-secret
    global.psql.password.key=postgres-password

    redis.install=false
    global.redis.host=${google_dns_record_set.postgres.name}
    global.redis.password.secret=gitlab-redis-secret
    global.redis.password.key=redis-password

    global.minio.enabled=false

    global.registry.bucket=${google_storage_bucket.gitlab-registry-storage.name}
    registry.storage.secret=registry-storage
    registry.storage.key=config
    registry.storage.extraKey=gcs.json

    global.appConfig.lfs.bucket=${google_storage_bucket.gitlab-lfs-storage}
    global.appConfig.lfs.connection.secret=gitlab-rails-storage
    global.appConfig.lfs.connection.key=connection

    global.appConfig.artifacts.bucket=${google_storage_bucket.gitlab-artifacts-storage}
    global.appConfig.artifacts.connection.secret=gitlab-rails-storage
    global.appConfig.artifacts.connection.key=connection

    global.appConfig.uploads.bucket=${google_storage_bucket.gitlab-uploads-storage}
    global.appConfig.uploads.connection.secret=gitlab-rails-storage
    global.appConfig.uploads.connection.key=connection

    global.appConfig.packages.bucket=${google_storage_bucket.gitlab-packages-storage}
    global.appConfig.packages.connection.secret=gitlab-rails-storage
    global.appConfig.packages.connection.key=connection

    global.appConfig.externalDiffs.bucket=${google_storage_bucket.gitlab-externaldiffs-storage}
    global.appConfig.externalDiffs.connection.secret=gitlab-rails-storage
    global.appConfig.externalDiffs.connection.key=connection

    global.appConfig.ldap.preventSignin: true

    global.appConfig.backups.bucket=${google_storage_bucket.gitlab-backup-storage}
    global.appConfig.backups.tmpBucket=${google_storage_bucket.gitlab-restore-storage}
    gitlab.toolbox.backups.objectStorage.backend=gcs
    gitlab.toolbox.backups.objectStorage.config.gcpProject=${var.project_id}
    gitlab.toolbox.backups.objectStorage.config.secret=backup-storage-config
    gitlab.toolbox.backups.objectStorage.config.key=config
    gitlab.toolbox.persistence.enabled=true
    gitlab.toolbox.backups.cron.persistence.enabled=true

  EOT
  filename        = "./outputs/gitlab-helm.txt"
  file_permission = "0666"
}
