# resource "yandex_resourcemanager_folder_iam_binding" "dataproc" {
#   folder_id = var.folder_id
#   role      = "dataproc.agent"
#   members = [
#     "serviceAccount:${data.yandex_iam_service_account.dataproc.id}",
#   ]
# }
