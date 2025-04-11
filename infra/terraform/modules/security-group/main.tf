resource "yandex_vpc_security_group" "sg" {
  name        = var.name
  description = var.description
  folder_id   = var.folder_id
  network_id  = var.vpc_id

  labels = var.labels
}
