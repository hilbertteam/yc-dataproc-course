module "airflow_sa" {
  source    = "../../modules/service-account"
  name      = var.airflow_sa_name
  folder_id = var.yc_folder_id
  folder_iam_roles = [
    "managed-airflow.integrationProvider",
    "vpc.user",
  ]
}