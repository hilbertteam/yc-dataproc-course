#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.2-dataproc-config.env

###
# Secority Group
###
# Получаем ID сети
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME | grep "^id:" | awk '{ print $2 }')
# Получаем идентификатор группы безопасности yc-toolbox
export TOOLBOX_SG_ID=$(yc vpc security-group get $TOOLBOX_SG_NAME | grep "^id:" | awk '{ print $2 }')
# Создаем Группу безопасности и правила в ней
yc vpc security-group get $DATAPROC_SG_NAME 2>/dev/null || yc vpc security-group create \
  --name $DATAPROC_SG_NAME \
  --rule "direction=ingress,port=any,protocol=any,predefined=self_security_group" \
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
export DATAPROC_SG_ID=$(yc vpc security-group get $DATAPROC_SG_NAME | grep "^id:" | awk '{ print $2 }')
# Создаем dataproc кластер
yc dataproc cluster create $DATAPROC_CLUSTER_NAME \
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
   --ui-proxy=true
