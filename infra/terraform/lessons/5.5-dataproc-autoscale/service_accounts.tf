module "terraform-s3-manager-sa" {
  source    = "../../modules/service-account"
  name      = "terraform-s3-manager-sa"
  folder_id = var.yc_folder_id
}

module "dataproc-sa" {
  source    = "../../modules/service-account"
  name      = var.dataproc_sa_name
  folder_id = var.yc_folder_id
  folder_iam_roles = [
    "editor"
  ]
}
