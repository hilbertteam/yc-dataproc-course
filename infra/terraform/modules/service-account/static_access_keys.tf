resource "yandex_iam_service_account_static_access_key" "sa-static-keys" {
  for_each = var.static_access_keys
  service_account_id = yandex_iam_service_account.sa.id
  description        = each.value
}