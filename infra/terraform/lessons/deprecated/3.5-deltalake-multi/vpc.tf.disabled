module "vpc" {
  source    = "../../modules/vpc"
  name      = "dataproc-21-tf"
  folder_id = var.yc_folder_id
}

module "subnet" {
  source = "../../modules/subnets"

  folder_id = var.yc_folder_id
  vpc_id    = module.vpc.vpc_id
  gateway   = true
  subnets = [
    {
      name = format("%s-%s", module.vpc.vpc_name, var.yc_zone)
      cidr = "10.22.0.0/24"
      zone = var.yc_zone
      nat  = true
    }
  ]
}