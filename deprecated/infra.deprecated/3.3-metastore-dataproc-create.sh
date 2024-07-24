#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/3.3-metastore-config.env

###
# Secority Group
###
# Получаем ID сети
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME --format json | jq -r ".id")

###
# DataProc Cluster
##
# Создаем пару ssh-ключей если не была создана ранее
test -f "$SSH_KEY_FILE" || ssh-keygen -t ed25519 -f $SSH_KEY_FILE -q -N ""
# Получаем ID группы безопасности
export DATAPROC_SG_ID=$(yc vpc security-group get $DATAPROC_SG_NAME --format json | jq -r ".id")
# Создаем dataproc кластер
yc dataproc cluster get $DATAPROC_CLUSTER_NAME 2>/dev/null || yc dataproc cluster create $DATAPROC_CLUSTER_NAME \
  --bucket=$S3_BUCKET_INFRA \
  --zone=$DATAPROC_ZONE_ID \
  --service-account-name=$DATAPROC_SA_NAME \
  --security-group-ids=$DATAPROC_SG_ID \
  --version=$DATAPROC_VERSION \
  --services="$DATAPROC_SERVICES" \
  --ssh-public-keys-file=${SSH_KEY_FILE}.pub \
  --subcluster name=$DATAPORC_SUBCLUSTER_MASTER_NAME,`
              `role=masternode,`
              `resource-preset=$DATAPORC_SUBCLUSTER_MASTER_RESOURCE_PRESET,`
              `disk-type=$DATAPORC_SUBCLUSTER_MASTER_DISK_TYPE,`
              `disk-size=$DATAPORC_SUBCLUSTER_MASTER_DISK_SIZE,`
              `subnet-name=$VPC_SUBNET_NAME,`
              `assign-public-ip=false \
  --subcluster name=$DATAPORC_SUBCLUSTER_COMPUTE_NAME,`
              `role=computenode,`
              `resource-preset=$DATAPORC_SUBCLUSTER_COMPUTE_RESOURCE_PRESET,`
              `disk-type=$DATAPORC_SUBCLUSTER_COMPUTE_DISK_TYPE,`
              `disk-size=$DATAPORC_SUBCLUSTER_COMPUTE_DISK_SIZE,`
              `subnet-name=$VPC_SUBNET_NAME,`
              `hosts-count=$DATAPORC_SUBCLUSTER_COMPUTE_HOSTS_COUNT,`
              `assign-public-ip=false \
  --deletion-protection=false \
  --ui-proxy=true \
  --property livy:livy.spark.deploy-mode=client \
  --property spark:spark.hive.metastore.uris=thrift://$METASTORE_IP:9083 \
  --property spark:spark.sql.warehouse.dir=s3a://$S3_BUCKET_DATA/warehouse \
  --property spark:spark.sql.hive.metastore.sharedPrefixes=com.amazonaws,ru.yandex.cloud
