module "clickhouse" {
  source  = "../../modules/clickhouse"
  network_id         = data.yandex_vpc_network.vpc.id
  cluster_name       = var.clickhouse_cluster_name
  environment        = "PRODUCTION"
  resource_preset_id = "s3-c2-m8"
  disk_size          = 50
  disk_type_id       = "network-ssd"
  database_version   = "24.8"

  access_web_sql     = true

  hosts = [
    {
      zone             = var.yc_zone
      subnet_id        = data.yandex_vpc_subnet.dataproc.id
      assign_public_ip = false
    }
  ]
  databases = [
    "dataproc-db"
  ]
  users = [
    {
      name     = "dataproc-user"
      password = var.clickhouse_password
      permissions = [
        "dataproc-db"
      ]
    },
  ]
}