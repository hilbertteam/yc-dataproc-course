module "terraform-s3-manager-sa" {
  source    = "../../modules/service-account"
  name      = "terraform-s3-manager-sa-tf"
  folder_id = var.yc_folder_id
  # folder_iam_roles = [
  #   "storage.admin"
  # ]
}

module "dataproc-sa" {
  source    = "../../modules/service-account"
  name      = "dataproc-sa-21-tf"
  folder_id = var.yc_folder_id
  folder_iam_roles = [
    "editor"
  ]
}

module "datasphere-sa" {
  source    = "../../modules/service-account"
  name      = "datasphere-sa-21-tf"
  folder_id = var.yc_folder_id
  folder_iam_roles = [
    "dataproc.agent",
    "vpc.user",
    "storage.admin"
  ]
}