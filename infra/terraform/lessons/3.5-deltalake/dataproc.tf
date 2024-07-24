locals {
  dataproc = {
    folder_id          = var.yc_folder_id
    service_account_id = data.yandex_iam_service_account.dataproc-sa.id
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
      # DataSphere connector DataProc
      "livy:livy.spark.deploy-mode" = "client",
      # MetaStore
      "spark:spark.sql.hive.metastore.sharedPrefixes" = "com.amazonaws,ru.yandex.cloud",
      "spark:spark.sql.warehouse.dir"                 = "s3a://${var.s3_bucket_data}/warehouse",
      "spark:spark.hive.metastore.uris"               = "thrift://${var.metastore_ip}:9083",
      # DeltaLake multi
      # "spark:spark.jars" = "s3a://${var.s3_bucket_tasks}/jars/yc-delta23-multi-dp21-1.2-fatjar.jar",
      # "spark:spark.sql.extensions" = "io.delta.sql.DeltaSparkSessionExtension",
      # "spark:spark.sql.catalog.spark_catalog" = "org.apache.spark.sql.delta.catalog.YcDeltaCatalog",
      # "spark:spark.delta.logStore.s3a.impl" = "ru.yandex.cloud.custom.delta.YcS3YdbLogStore",
      # "spark:spark.io.delta.storage.S3DynamoDBLogStore.ddb.endpoint" = module.ydb-database.document_api_endpoint,
      # "spark:spark.io.delta.storage.S3DynamoDBLogStore.ddb.lockbox" = module.lockbox-ydb.secret_id,
      # "spark:spark.debug.maxToStringFields" = 200
      # DeltaLake single
      "spark:spark.jars"                       = "s3a://${var.s3_bucket_tasks}/jars/delta-core_2.12-2.3.0.jar,s3a://${var.s3_bucket_tasks}/jars/delta-storage-2.3.0.jar",
      "spark:spark.sql.extensions"             = "io.delta.sql.DeltaSparkSessionExtension",
      "spark:spark.debug.maxToStringFields"    = 200,
      "spark:spark.sql.catalog.spark_catalog"  = "org.apache.spark.sql.delta.catalog.DeltaCatalog",
      "spark:spark.sql.catalogImplementation"  = "hive",
      "spark:spark.sql.repl.eagerEval.enabled" = "true"
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
}

module "dataproc-cluster-delta1" {
  source = "../../modules/dataproc-cluster"
  name   = var.dataproc_cluster1_name
  bucket = module.s3-dataproc-delta1-infra.bucket

  folder_id          = local.dataproc.folder_id
  service_account_id = local.dataproc.service_account_id
  zone_id            = local.dataproc.zone_id
  ui_proxy           = local.dataproc.ui_proxy
  security_group_ids = local.dataproc.security_group_ids
  version_id         = local.dataproc.version_id
  services           = local.dataproc.services
  properties         = local.dataproc.properties
  ssh_public_keys    = local.dataproc.ssh_public_keys
  subclusters        = local.dataproc.subclusters

  depends_on = [
    yandex_storage_object.delta-core-jar,
    yandex_storage_object.delta-storage-jar,
  ]
}

module "dataproc-cluster-delta2" {
  source = "../../modules/dataproc-cluster"
  name   = var.dataproc_cluster2_name
  bucket = module.s3-dataproc-delta2-infra.bucket

  folder_id          = local.dataproc.folder_id
  service_account_id = local.dataproc.service_account_id
  zone_id            = local.dataproc.zone_id
  ui_proxy           = local.dataproc.ui_proxy
  security_group_ids = local.dataproc.security_group_ids
  version_id         = local.dataproc.version_id
  services           = local.dataproc.services
  properties         = local.dataproc.properties
  ssh_public_keys    = local.dataproc.ssh_public_keys
  subclusters        = local.dataproc.subclusters

  depends_on = [
    yandex_storage_object.delta-core-jar,
    yandex_storage_object.delta-storage-jar,
  ]
}
