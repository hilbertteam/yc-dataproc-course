#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.7-datasphere-config-2.1.env

###
# Secority Group
###
# Получаем ID сети
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME --format json | jq -r ".id")

# Создаем группу безопасности для DataSphere
yc vpc security-group get $DATASPHERE_SG_NAME 2>/dev/null || yc vpc security-group create \
  --name $DATASPHERE_SG_NAME \
  --rule "direction=egress,port=any,protocol=any,v4-cidrs=[0.0.0.0/0]" \
  --network-id $VPC_NETWORK_ID
# Получаем идентификатор группы безопасности DataSphere
export DATASPHERE_SG_ID=$(yc vpc security-group get $DATASPHERE_SG_NAME --format json | jq -r ".id")


# Получаем идентификатор группы безопасности yc-toolbox
export TOOLBOX_SG_ID=$(yc vpc security-group get $TOOLBOX_SG_NAME --format json | jq -r ".id")
# Создаем Группу безопасности и правила в ней
yc vpc security-group get $DATAPROC_SG_NAME 2>/dev/null || yc vpc security-group create \
  --name $DATAPROC_SG_NAME \
  --rule "direction=ingress,port=any,protocol=any,predefined=self_security_group" \
  --rule "direction=ingress,port=any,protocol=any,security-group-id=$DATASPHERE_SG_ID" \
  --rule "direction=ingress,port=22,protocol=tcp,security-group-id=$TOOLBOX_SG_ID" \
  --rule "direction=egress,port=any,protocol=any,predefined=self_security_group" \
  --rule "direction=egress,port=123,protocol=udp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=egress,port=80,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=egress,port=443,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --network-id $VPC_NETWORK_ID

###
# DataProc Cluster
##
# Создаем пару ssh-ключей если не была создана ранее
test -f "$SSH_KEY_FILE" || ssh-keygen -t ed25519 -f $SSH_KEY_FILE -q -N ""
# Получаем ID группы безопасности
# export DATAPROC_SG_ID=$(yc vpc security-group get $DATAPROC_SG_NAME --format json | jq -r ".id")
# default-sg
export DATAPROC_SG_ID=enpr20t06p1fchlm2neo
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
   --property yarn:yarn.node-labels.fs-store.root-dir=file:///hadoop/yarn/node-labels \
   --property yarn:yarn.node-labels.enabled=true \
   --property yarn:yarn.node-labels.configuration-type=centralized \
   --property capacity-scheduler:yarn.scheduler.capacity.maximum-am-resource-percent=1.00 \
   --property capacity-scheduler:yarn.scheduler.capacity.root.default.accessible-node-labels=SPARKAM \
   --property capacity-scheduler:yarn.scheduler.capacity.root.accessible-node-labels.SPARKAM.capacity=100 \
   --property capacity-scheduler:yarn.scheduler.capacity.root.default.accessible-node-labels.SPARKAM.capacity=100 \
   --property capacity-scheduler:yarn.scheduler.capacity.resource-calculator=org.apache.hadoop.yarn.util.resource.DominantResourceCalculator \
   --property spark:spark.yarn.am.nodeLabelExpression=SPARKAM \
   --property livy:livy.spark.deploy-mode=client \
   --property core:fs.s3a.committer.threads=100 \
   --property core:fs.s3a.connection.maximum=1000 \
   --property core:mapreduce.outputcommitter.factory.scheme.s3a=org.apache.hadoop.fs.s3a.commit.S3ACommitterFactory \
   --property core:yarn.system-metrics-publisher.enabled=true \
   --property spark:spark.sql.sources.commitProtocolClass=org.apache.spark.internal.io.cloud.PathOutputCommitProtocol \
   --property spark:spark.sql.parquet.output.committer.class=org.apache.spark.internal.io.cloud.BindingParquetOutputCommitter \
   --property spark:spark.hadoop.hive.metastore.uris=thrift://10.128.0.5:9083 \
   --property spark:spark.sql.warehouse.dir=s3a://test-warehouse/warehouse \
   --property spark:spark.serializer=org.apache.spark.serializer.KryoSerializer \
   --property spark:spark.kryoserializer.buffer=32m \
   --property spark:spark.kryoserializer.buffer.max=256m \
   --property spark:spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
   --property spark:spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog \
   --property spark:spark.sql.hive.metastore.sharedPrefixes=com.amazonaws,ru.yandex.cloud \
   --property spark:spark.sql.addPartitionInBatch.size=1000
   --deletion-protection=false \
   --ui-proxy=true

#    --property spark:spark.jars=s3a://${YC_BUCKET}/jars/yc-delta23-multi-dp21-1.1-fatjar.jar,s3a://${YC_BUCKET}/jars/ydb-spark-connector-1.1.jar \

###
# Service Account
###
# Создаем сервисный аккаунт datasphere-sa
yc iam service-account create $DATASPHERE_SA_NAME

# Получаем id сервисного аккаунта datasphere-sa
export DATASPHERE_SA_ID=$(yc iam service-account get $DATASPHERE_SA_NAME --format json | jq -r ".id")
# Назначаем сервисному аккаунту роли
yc resource-manager folder add-access-binding dataproc \
  --role vpc.user \
  --subject serviceAccount:$DATASPHERE_SA_ID
yc resource-manager folder add-access-binding dataproc \
  --role dataproc.agent \
  --subject serviceAccount:$DATASPHERE_SA_ID

# ###
# # DataSphere
# ###
# # Готовим providers.tf
# cd ./terraform
# ./prepare.sh
# cd -
# # Создаем DataSphere
# cd ./terraform/datasphere
# terraform init -upgrade && terraform plan && terraform apply -auto-approve
# cd -