module "dataproc-course" {
  source             = "../../modules/dataproc-cluster"
  name               = "dataproc-course-21"
  folder_id          = var.yc_folder_id
  service_account_id = module.dataproc-sa.sa_id
  bucket             = module.s3-dataproc-infra.bucket
  zone_id            = var.yc_zone
  ui_proxy           = true
  security_group_ids = [
    data.yandex_vpc_security_group.default.id
  ]
  version_id = "2.1"
  services = [
    "YARN",
    "SPARK"
  ]
  ssh_public_keys = [
    file("~/.ssh/id_ed25519.pub")
  ]
  subclusters = {
    main = {
      role               = "MASTERNODE"
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 128
      hosts_count        = 1
      subnet_id          = module.subnet.subnet_ids[format("%s-%s", module.vpc.vpc_name, var.yc_zone)]
      assign_public_ip   = false
    }
    compute = {
      role               = "COMPUTENODE"
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 20
      hosts_count        = 1
      subnet_id          = module.subnet.subnet_ids[format("%s-%s", module.vpc.vpc_name, var.yc_zone)]
      assign_public_ip   = false
    }
  }

}