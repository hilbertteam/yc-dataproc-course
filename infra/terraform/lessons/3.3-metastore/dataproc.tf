module "dataproc-cluster" {
  source             = "../../modules/dataproc-cluster"
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
    "LIVY",
  ]
  properties = {
    "livy:livy.spark.deploy-mode" = "client",
    "spark:spark.sql.hive.metastore.sharedPrefixes" = "com.amazonaws,ru.yandex.cloud",
    "spark:spark.sql.warehouse.dir" = "s3a://${var.s3_bucket_data}/warehouse",
    "spark:spark.hive.metastore.uris" = "thrift://${var.metastore_ip}:9083"
  }

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
      assign_public_ip   = false
    }
    compute = {
      role               = "COMPUTENODE"
      resource_preset_id = "s3-c2-m8"
      disk_type_id       = "network-ssd"
      disk_size          = 50
      hosts_count        = 1
      subnet_id          = data.yandex_vpc_subnet.dataproc.id
      assign_public_ip   = false
    }
  }
}
