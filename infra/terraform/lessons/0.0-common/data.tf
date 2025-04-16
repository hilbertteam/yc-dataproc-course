# data "yandex_compute_instance" "yc-toolbox" {
#   instance_id = var.yc_toolbox_instance_id
# }

data "yandex_vpc_network" "vpc" {
  name = var.vpc_network_name
}

data "yandex_iam_service_account" "toolbox-sa" {
  name = var.toolbox_sa_name
}