# // Grant permissions
# resource "yandex_resourcemanager_folder_iam_member" "sa-admin" {
#   folder_id = var.folder_id
#   role      = "storage.admin"
#   member    = "serviceAccount:${data.yandex_iam_service_account.sa.id}"
# }

// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
  service_account_id = data.yandex_iam_service_account.sa.id
  description        = format("Manage s3 bucket %s", var.bucket)
}

// Use keys to create bucket
resource "yandex_storage_bucket" "bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-static-key.secret_key
  folder_id = var.folder_id
  bucket = var.bucket
  max_size = var.max_size
  default_storage_class = var.default_storage_class
  tags = var.tags
  policy = var.policy
  force_destroy = var.force_destroy

  versioning {
    enabled = var.versioning_enabled
  }

  # depends_on = [
  #   yandex_resourcemanager_folder_iam_member.sa-admin
  # ]
}
