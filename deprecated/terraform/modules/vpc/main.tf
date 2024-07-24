resource "yandex_vpc_network" "vpc" {
  name = var.name
  folder_id = var.folder_id
}