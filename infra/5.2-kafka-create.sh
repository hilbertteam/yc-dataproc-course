#!/bin/bash

set -eux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.2-dataproc.env
source `dirname "$(realpath $0)"`/5.2-kafka.env


###
# Kafka
###
# Получаем ID сети
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME | grep "^id:" | awk '{ print $2 }')
# Получаем идентификатор группы безопасности yc-toolbox
export TOOLBOX_SG_ID=$(yc vpc security-group get $TOOLBOX_SG_NAME | grep "^id:" | awk '{ print $2 }')
# Получаем идентификатор группы безопасности dataproc-кластера
export DATAPROC_SG_ID=$(yc vpc security-group get $DATAPROC_SG_NAME | grep "^id:" | awk '{ print $2 }')
# Создаем группу безопасности
yc vpc security-group get $KAFKA_SG_NAME || yc vpc security-group create \
  --name $KAFKA_SG_NAME \
  --rule "direction=ingress,from-port=9091,to-port=9092,protocol=tcp,predefined=self_security_group" \
  --rule "direction=ingress,from-port=9091,to-port=9092,protocol=tcp,security-group-id=$TOOLBOX_SG_ID" \
  --rule "direction=ingress,from-port=9091,to-port=9092,protocol=tcp,security-group-id=$DATAPROC_SG_ID" \
  --rule "direction=ingress,from-port=9091,to-port=9092,protocol=tcp,v4-cidrs=$KAFKA_ALLOWED_CIDRS" \
  --rule "direction=ingress,port=443,protocol=tcp,predefined=self_security_group" \
  --network-id $VPC_NETWORK_ID
# Получаем идентификатор группы безопасности
export KAFKA_SG_ID=$(yc vpc security-group get $KAFKA_SG_NAME | grep "^id:" | awk '{ print $2 }')
# Получаем идентификатор подсети
export KAFKA_SUBNET_ID=$(yc vpc subnet get $KAFKA_SUBNET_NAME | grep "^id:" | awk '{ print $2 }')
# Создаем кластер
yc managed-kafka cluster get --name $KAFKA_CLUSTER_NAME || yc managed-kafka cluster create $KAFKA_CLUSTER_NAME \
  --environment $KAFKA_ENVIRONMENT \
  --version $KAFKA_VERSION \
  --network-name $VPC_NETWORK_NAME \
  --zone-ids $KAFKA_ZONE_IDS \
  --subnet-ids $KAFKA_SUBNET_ID \
  --brokers-count $KAFKA_BROKERS_COUNT \
  --resource-preset $KAFKA_RESOURCE_PRESET \
  --disk-type $KAFKA_DISK_TYPE \
  --disk-size $KAFKA_DISK_SIZE \
  --security-group-ids ${KAFKA_SG_ID} \
  ${KAFKA_ASSIGN_PUBLIC_IP}

# Разрешаем 
yc vpc security-group update-rules $DATAPROC_SG_NAME \
  --add-rule "direction=egress,from-port=9091,to-port=9092,protocol=tcp,security-group-id=$KAFKA_SG_ID"

# Создаем пользователя с правами admin
yc managed-kafka user get $KAFKA_ADMIN_USER --cluster-name $KAFKA_CLUSTER_NAME || yc managed-kafka user create $KAFKA_ADMIN_USER \
  --cluster-name $KAFKA_CLUSTER_NAME \
  --password $KAFKA_ADMIN_PASSWORD \
  --permission topic=*,role=admin

# Создаем топик
yc managed-kafka topic create $KAFKA_TOPIC_NAME \
  --cluster-name $KAFKA_CLUSTER_NAME \
  --partitions $KAFKA_TOPIC_PARTITIONS \
  --replication-factor $KAFKA_TOPIC_REPLICATION_FACTOR
