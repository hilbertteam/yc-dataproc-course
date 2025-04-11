output "database_id" {
  value = yandex_ydb_database_serverless.database.id
  description = "ID of the Yandex Database serverless cluster"
}

output "document_api_endpoint" {
  value = yandex_ydb_database_serverless.database.document_api_endpoint
  description = "Document API endpoint of the Yandex Database serverless cluster"
}

output "ydb_full_endpoint" {
  value = yandex_ydb_database_serverless.database.ydb_full_endpoint
  description = "Full endpoint of the Yandex Database serverless cluster"
}

output "ydb_api_endpoint" {
  value = yandex_ydb_database_serverless.database.ydb_api_endpoint
  description = "API endpoint of the Yandex Database serverless cluster. Useful for SDK configuration"
}

output "database_path" {
  value = yandex_ydb_database_serverless.database.database_path
  description = "Full database path of the Yandex Database serverless cluster. Useful for SDK configuration"
}

output "tls_enabled" {
  value = yandex_ydb_database_serverless.database.tls_enabled
  description = "Whether TLS is enabled for the Yandex Database serverless cluster. Useful for SDK configuration"
}

output "created_at" {
  value = yandex_ydb_database_serverless.database.created_at
  description = "The Yandex Database serverless cluster creation timestamp"
}

output "status" {
  value = yandex_ydb_database_serverless.database.status
  description = "Status of the Yandex Database serverless cluster"
}
