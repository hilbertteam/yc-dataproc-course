# data "yandex_compute_instance" "yc-toolbox" {
#   instance_id = var.yc_toolbox_instance_id
# }

data "yandex_vpc_network" "vpc" {
  name = var.vpc_network_name
}

data "yandex_vpc_subnet" "dataproc" {
  name = var.dataproc_subnet_name
}

data "yandex_vpc_security_group" "default" {
  name = format("default-sg-%s", data.yandex_vpc_network.vpc.id)
}

data "yandex_iam_service_account" "dataproc-sa" {
  name = var.dataproc_sa_name
}

data "yandex_iam_service_account" "datasphere-sa" {
  name = var.datasphere_sa_name
}

data "yandex_iam_service_account" "terraform-s3-manager-sa" {
  name = "terraform-s3-manager-sa"
}
