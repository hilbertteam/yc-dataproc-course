variable "yc_cloud_id" {
  type = string
}

variable "yc_folder_id" {
  type = string
}

variable "yc_zone" {
  type = string
}

variable "yc_token" {
  type = string
}

variable "airflow_sa_name" {
  type = string
  default = "airflow-sa"
}

variable "s3_bucket_dags" {
  type = string
}