resource "yandex_dataproc_cluster" "dataproc" {
  # depends_on = [yandex_resourcemanager_folder_iam_binding.dataproc]

  bucket              = var.bucket
  description         = var.description
  name                = var.name
  labels              = var.labels
  service_account_id  = data.yandex_iam_service_account.dataproc.service_account_id
  zone_id             = var.zone_id
  ui_proxy            = var.ui_proxy
  deletion_protection = var.deletion_protection
  security_group_ids  = var.security_group_ids

  cluster_config {
    # Certain cluster version can be set, but better to use default value (last stable version)
    # version_id = "2.0"
    version_id = var.version_id

    hadoop {
      services        = var.services
      properties      = var.properties
      ssh_public_keys = var.ssh_public_keys
      # initialization_action {
      #   uri  = "s3a://yandex_storage_bucket.foo.bucket/scripts/script.sh"
      #   args = ["arg1", "arg2"]
      # }
    }

    dynamic "subcluster_spec" {
      for_each = var.subclusters
      content {
        name = subcluster_spec.key
        role = subcluster_spec.value.role
        resources {
          resource_preset_id = subcluster_spec.value.resource_preset_id
          disk_type_id       = subcluster_spec.value.disk_type_id
          disk_size          = subcluster_spec.value.disk_size
        }
        hosts_count      = subcluster_spec.value.hosts_count
        subnet_id        = subcluster_spec.value.subnet_id
        assign_public_ip = subcluster_spec.value.assign_public_ip
      }
    }
  }
}
