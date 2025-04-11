# data "yandex_compute_instance" "yc-toolbox" {
#   instance_id = var.yc_toolbox_instance_id
# }

data "yandex_vpc_security_group" "default" {
  name = format("default-sg-%s", module.vpc.vpc_id)
}
