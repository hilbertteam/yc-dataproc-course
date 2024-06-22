resource "yandex_iam_service_account" "sa" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "sa" {
  for_each = toset(var.folder_iam_roles)
  folder_id = var.folder_id
  role      = each.value
  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
}