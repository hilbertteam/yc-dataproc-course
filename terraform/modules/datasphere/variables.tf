variable "yc_organisation_id" {
  type = string
}

variable "yc_billing_account_id" {
  type = string
  default = null
}

variable "service_account_id" {
  type = string
}

variable "vpc_subnet_id" {
  type = string
}

variable "dataproc_cluster_id" {
  type = string
}

variable "security_group_ids" {
  type = list(string)
  default = []
}

variable "default_folder_id" {
  type = string
  default = null
}

variable "datasphere_community_name" {
  type = string
  default = null
}

variable "datasphere_community_id" {
  type = string
  default = null
}

variable "datasphere_project_name" {
  type = string
}

variable "datasphere_project_descr" {
  type = string
  default = ""
}

variable "stale_exec_timeout_mode" {
  type = string
  default = "ONE_HOUR"
}