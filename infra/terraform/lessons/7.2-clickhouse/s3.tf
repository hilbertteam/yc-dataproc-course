###
# Copy jars to s3_bucket_tasks
###
// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "tf-mgmt-sa-static-key" {
  service_account_id = data.yandex_iam_service_account.terraform-s3-manager-sa.id
  description        = format("Upload objects to s3 bucket %s", var.s3_bucket_tasks)
}

resource "yandex_storage_object" "clickhouse-jdbc-jar" {
  bucket = var.s3_bucket_tasks
  key    = "jars/clickhouse-jdbc-0.6.5.jar"
  source = "${path.module}/../../../jars/clickhouse-jdbc-0.6.5.jar"
  access_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.secret_key
}