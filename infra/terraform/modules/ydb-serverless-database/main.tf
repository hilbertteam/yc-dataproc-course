resource "yandex_ydb_database_serverless" "database" {
  name      = var.name
  folder_id = var.folder_id
  description = var.description
  location_id = var.location_id
  labels = var.labels

  deletion_protection = var.deletion_protection
}