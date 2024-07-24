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

variable "dataproc_cluster1_name" {
  type = string
  default = "dataproc-course-delta1"
}

variable "dataproc_cluster2_name" {
  type = string
  default = "dataproc-course-delta2"
}

variable "metastore_ip" {
  type = string
}

variable "dataproc_sa_name" {
  type = string
  default = "dataproc-sa"
}

variable "s3_bucket_dataproc1" {
  type = string
}

variable "s3_bucket_dataproc2" {
  type = string
}

variable "s3_bucket_data" {
  type = string
}

variable "s3_bucket_tasks" {
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

variable "datasphere_sa_name" {
  type = string
  default = "datasphere-sa"
}

# variable "datasphere_community_id" {
#   type = string
# }

variable "yc_organisation_id" {
  type = string
}