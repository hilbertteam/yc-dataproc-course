resource "random_password" "pwd" {
  length           = 18
  special          = true
  override_special = "_!@"
}

resource "yandex_mdb_clickhouse_cluster" "managed_clickhouse" {
  name        = var.cluster_name
  network_id  = var.network_id
  description = var.description
  labels      = var.labels
  environment = var.environment
  version     = var.database_version

  clickhouse {
    resources {
      resource_preset_id = var.resource_preset_id
      disk_size          = var.disk_size
      disk_type_id       = var.disk_type_id
    }
  }

  zookeeper {
    resources {
      resource_preset_id = var.zk_resource_preset_id
      disk_type_id       = var.zk_disk_type_id
      disk_size          = var.zk_disk_size
    }
  }

  dynamic "user" {
    for_each = var.users
    content {
      name = user.value["name"]
      password = user.value["password"] == "" || user.value["password"] == null ? random_password.pwd.result : user.value["password"]
      dynamic "permission" {
        for_each = toset(user.value["permissions"])
        content {
          database_name = permission.value
        }
      }
    }
  }

  dynamic "database" {
    for_each = toset(var.databases)
    content {
      name = database.value
    }
  }


  # by default reserved "shard1" will be created and applied
  dynamic "shard" {
    for_each = var.shards
    content {
      name = shard.value
    }
  }

  dynamic "host" {
    for_each = var.hosts
    content {
      zone             = host.value.zone
      subnet_id        = host.value.subnet_id
      type             = "CLICKHOUSE"
      assign_public_ip = host.value.assign_public_ip
      # by default reserved "shard1" will be created and applied
      shard_name = host.value.shard_name == "" ? null : host.value.shard_name
    }
  }

  dynamic "host" {
    for_each = var.zk_hosts
    content {
      zone      = host.value.zone
      subnet_id = host.value.subnet_id
      type      = "ZOOKEEPER"
    }
  }

  backup_window_start {
    hours   = var.backup_window_start_hours
    minutes = var.backup_window_start_minutes
  }

  access {
    data_lens = var.access_data_lens
    web_sql   = var.access_web_sql
  }
}