module "lockbox-ydb" {
  source = "../../modules/lockbox"
  folder_id = var.yc_folder_id
  name = "dataproc-course-lockbox-ydb"
  description = "Secret to manage ydb for deltalake"

  secret_version_text_entries = {
    "key-id" = {
      key = "key-id"
      text_value = module.terraform-ydb-manager-sa.sa_static_access_keys["manage_ydb"].access_key
    }
    "key-secret" = {
      key = "key-secret"
      text_value = module.terraform-ydb-manager-sa.sa_static_access_keys["manage_ydb"].secret_key
    }
  }
}