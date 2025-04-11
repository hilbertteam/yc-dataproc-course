module "dataproc-cluster" {
  source             = "../../modules/dataproc-cluster-autoscale"
  name               = var.dataproc_cluster_name
  folder_id          = var.yc_folder_id
  service_account_id = data.yandex_iam_service_account.dataproc-sa.id
  bucket             = module.s3-dataproc-infra.bucket
  zone_id            = var.yc_zone
  ui_proxy           = true
  security_group_ids = [
    data.yandex_vpc_security_group.default.id
  ]
  version_id = "2.1"
  services = [
    "YARN",
    "SPARK",
  ]
  # properties = {
  #   "livy:livy.spark.deploy-mode" = "client"
  # }
  ssh_public_keys = [
    file(format("%s.pub", var.ssh_key_file))
  ]
  subclusters = {
    main = {
      role               = "MASTERNODE"
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 50
      hosts_count        = 1
      subnet_id          = data.yandex_vpc_subnet.dataproc.id
      assign_public_ip   = true
      autoscaling_config = {
        enabled                 = false
        max_hosts_count         = 0
        measurement_duration    = 0
        warmup_duration         = 0
        stabilization_duration  = 0
        preemptible             = false
        decommission_timeout    = 0
        cpu_utilization_target  = 0.0
      }
    }
    compute = {
      role               = "COMPUTENODE"
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 50
      hosts_count        = 1
      subnet_id          = data.yandex_vpc_subnet.dataproc.id
      assign_public_ip   = false
      autoscaling_config = {
        enabled                 = true
        max_hosts_count         = 3
        measurement_duration    = 60
        warmup_duration         = 60
        stabilization_duration  = 120
        preemptible             = false
        decommission_timeout    = 60
        cpu_utilization_target  = var.cpu_utilization_target != 0.0 ? var.cpu_utilization_target : 0.0
      }
    }
  }
}

