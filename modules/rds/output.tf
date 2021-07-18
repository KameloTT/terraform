output "gitlab_database_endpoint" {
  value = module.rds.this_db_instance_address
}

output "gitlab_database_password" {
  value = module.rds.this_db_instance_password
}

output "praefect_database_endpoint" {
  value = module.rds-storage.this_db_instance_address
}

output "praefect_database_password" {
  value = module.rds-storage.this_db_instance_password
}
