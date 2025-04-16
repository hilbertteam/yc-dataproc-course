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

variable "ssh_key_file" {
  type = string
  default = "~/.ssh/id_ed25519"
}

variable "terraform_sa_name" {
  type = string
  default = "terraform-s3-manager-sa"
}

variable "vpc_network_name" {
  type = string
  default = "dataproc"
}

variable "dataproc_subnet_name" {
  type = string
  default = "dataproc-dataproc-cluster"
}

variable "dataproc_subnet_cidr" {
  type = string
  default = "10.40.0.0/24"
}

variable "toolbox_sa_name" {
  type = string
  default = "toolbox-sa"
}

variable "dataproc_sa_name" {
  type = string
  default = "dataproc-sa"
}

variable "datasphere_sa_name" {
  type = string
  default = "datasphere-sa"
}

variable "airflow_sa_name" {
  type = string
  default = "airflow-sa"
}

variable "s3_bucket_data" {
  type = string
}

variable "s3_bucket_tasks" {
  type = string
}
