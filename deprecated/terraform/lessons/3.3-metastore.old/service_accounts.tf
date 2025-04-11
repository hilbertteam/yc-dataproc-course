module "terraform-s3-manager-sa" {
  source    = "../../modules/service-account"
  name      = "terraform-s3-manager-sa"
  folder_id = var.yc_folder_id
}

module "dataproc-sa" {
  source    = "../../modules/service-account"
  name      = "dataproc-sa-21"
  folder_id = var.yc_folder_id
  folder_iam_roles = [
    "editor"
  ]
}