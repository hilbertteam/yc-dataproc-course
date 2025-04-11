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

variable "dataproc_cluster_name" {
  type = string
  default = "dataproc-course"
}

variable "dataproc_sa_name" {
  type = string
  default = "dataproc-sa"
}

variable "s3_bucket_dataproc" {
  type = string
}

variable "s3_bucket_data" {
  type = string
}

variable "vpc_network_name" {
  type = string
  default = "dataproc"
}

variable "dataproc_subnet_name" {
  type = string
  default = "dataproc-cluster-ru-central1-a"
}

variable "toolbox_name" {
  type = string
  default = "yc-toolbox"
}

variable "toolbox_sg_name" {
  type = string
  default = "toolbox-sg"
}

variable "toolbox_sa_name" {
  type = string
  default = "toolbox-sa"
}

variable "yc_organization_id" {
  type = string
  default = ""
}

variable "yc_billing_account_id" {
  type = string
  default = ""
}

variable "enable_autoscaling" {
  description = "Enable autoscaling configuration"
  type        = bool
  default     = false
}

variable "cpu_utilization_target" {
  description = "The target CPU utilization for the autoscaling configuration"
  type        = number
  default     = 0.0
}