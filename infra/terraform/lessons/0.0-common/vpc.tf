module "subnet" {
  source = "../../modules/subnets"

  folder_id = var.yc_folder_id
  vpc_id    = data.yandex_vpc_network.vpc.id
  gateway   = true
  subnets = [
    {
      name = var.dataproc_subnet_name
      cidr = var.dataproc_subnet_cidr
      zone = var.yc_zone
      nat  = true
    }
  ]
}