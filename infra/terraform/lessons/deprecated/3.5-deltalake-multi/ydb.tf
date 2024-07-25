module "ydb-database" {
  source = "../../modules/ydb-serverless-database"
  folder_id = var.yc_folder_id
  name = "dataproc-course-ydb-deltalake"
  description = "YDB database for multicluster deltalake"
}