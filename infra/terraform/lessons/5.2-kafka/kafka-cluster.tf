module "kafka" {
  source = "../../modules/kafka"

  security_groups_ids_list = [yandex_vpc_security_group.kafka_sg.id, ]
  name       = "kafka-cluster"
  network_id = data.yandex_vpc_network.vpc.id
  subnet_ids = [yandex_vpc_subnet.sub_a.id]
  zones      = ["ru-central1-a"]
  kafka_config = {
    compression_type = "COMPRESSION_TYPE_ZSTD"
  }
  connectors = []
  topics = [
    {
      name                = "dataproc"
      partitions          = 1
      replication_factor  = 1
    }
  ]

  users = [
    {
      name = "dataproc-user"
      permissions = [
        { "topic_name" : "*"
        "role" : "ACCESS_ROLE_ADMIN" }
      ]
    },
  ]

  maintenance_window = {
    type : "ANYTIME"
  }

}
