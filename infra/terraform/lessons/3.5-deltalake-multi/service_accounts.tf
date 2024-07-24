module "terraform-ydb-manager-sa" {
  source    = "../../modules/service-account"
  name      = "terraform-ydb-manager-sa"
  folder_id = var.yc_folder_id
  folder_iam_roles = [
    "ydb.editor"
  ]

  static_access_keys = {
    "manage_ydb" = "manage ydb for deltalake"
  }
}