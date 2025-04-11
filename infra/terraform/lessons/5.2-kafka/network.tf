# VPC and Subnets
resource "yandex_vpc_subnet" "sub_a" {
  name           = "kafka-subnet"
  zone           = "ru-central1-a"
  network_id     = data.yandex_vpc_network.vpc.id
  v4_cidr_blocks = ["10.1.0.0/24"] 
}

# Security Group
resource "yandex_vpc_security_group" "kafka_sg" {
  name        = "sg-kafka"
  description = "kafka security group"
  network_id  = data.yandex_vpc_network.vpc.id

  ingress {
    protocol       = "ANY"
    description    = "incoming-kafka"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }

  egress {
    protocol       = "ANY"
    description    = "outgoing-all"
    v4_cidr_blocks = ["0.0.0.0/0"]
    from_port      = 0
    to_port        = 65535
  }
}