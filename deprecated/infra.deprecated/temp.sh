#!/bin/bash

set -eux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/config.env

# # Получаем id сервисного аккаунта
# export S3_SA_ID=$(yc iam service-account get $S3_SA_NAME | grep "^id:" | awk '{ print $2 }')

# # Генерируем json-файл с политиками из шаблона
# envsubst < templates/s3-sa-policy.json

# Создаем nat gateway
# yc vpc gateway create \
#   --name $NAT_GATEWAY_NAME

# export NAT_GAEWAY_ID=$(yc vpc gateway get --name $NAT_GATEWAY_NAME | grep "^id:" | awk '{ print $2 }')
# yc vpc route-table create $ROUTE_TABLE_NAME \
#    --network-name=$VPC_NETWORK_NAME \
#    --route destination=0.0.0.0/0,gateway-id=$NAT_GAEWAY_ID
# yc vpc subnet update $VPC_SUBNET_NAME \
#    --route-table-name=$ROUTE_TABLE_NAME

###
# Security groups
###
# Получаем ID сети
# export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME | grep "^id:" | awk '{ print $2 }')
# # Создаем Группу безопасности и правила в ней
# yc vpc security-group create \
#   --name $SG_NAME \
#   --rule "direction=ingress,port=any,protocol=any,predefined=self_security_group" \
#   --rule "direction=egress,port=any,protocol=any,predefined=self_security_group" \
#   --rule "direction=egress,port=123,protocol=udp,v4-cidrs=[0.0.0.0/0]" \
#   --network-id $VPC_NETWORK_ID


# ###
# # DataProc Cluster
# ###
# # Создаем пару ssh-ключей если не была создана ранее
# test -f "$SSH_KEY_FILE" || ssh-keygen -t ed25519 -f $SSH_KEY_FILE -q -N ""
# # Получаем ID группы безопасности
# export SG_ID=$(yc vpc security-group get $SG_NAME | grep "^id:" | awk '{ print $2 }')
# # Создаем dataproc кластер
# yc dataproc cluster create $DATAPROC_CLUSTER_NAME \
#    --bucket=$S3_BUCKET_INFRA \
#    --zone=$VPC_SUBNET_NAME \
#    --service-account-name=$DATAPROC_SA_NAME \
#    --version=$DATAPROC_VERSION \
#    --services="$DATAPROC_SERVICES" \
#    --ssh-public-keys-file=${SSH_KEY_FILE}.pub \
#    --subcluster name=$DATAPORC_SUBCLUSTER_MASTER_NAME,`
#                `role=masternode,`
#                `resource-preset=$DATAPORC_SUBCLUSTER_MASTER_RESOURCE_PRESET,`
#                `disk-type=$DATAPORC_SUBCLUSTER_MASTER_DISK_TYPE,`
#                `disk-size=$DATAPORC_SUBCLUSTER_MASTER_DISK_SIZE,`
#                `subnet-name=$VPC_SUBNET_NAME,`
#                `assign-public-ip=false \
#    --subcluster name=$DATAPORC_SUBCLUSTER_COMPUTE_NAME,`
#                `role=computenode,`
#                `resource-preset=$DATAPORC_SUBCLUSTER_COMPUTE_RESOURCE_PRESET,`
#                `disk-type=$DATAPORC_SUBCLUSTER_COMPUTE_DISK_TYPE,`
#                `disk-size=$DATAPORC_SUBCLUSTER_COMPUTE_DISK_SIZE,`
#                `subnet-name=$VPC_SUBNET_NAME,`
#                `hosts-count=$DATAPORC_SUBCLUSTER_COMPUTE_HOSTS_COUNT,`
#                `assign-public-ip=false \
#    --deletion-protection=false \
#    --ui-proxy=true \
#    --security-group-ids=$SG_ID


kafkacat -C \
         -b rc1d-710ksn4mb05ijdkt.mdb.yandexcloud.net:9091 \
         -t dataproc-topic \
         -X security.protocol=SASL_SSL \
         -X sasl.mechanism=SCRAM-SHA-512 \
         -X sasl.username="dataprocadm" \
         -X sasl.password="jiegaing1iJohcu1" \
         -X ssl.ca.location=/usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt -Z

echo "test message" | kafkacat -P \
       -b rc1d-710ksn4mb05ijdkt.mdb.yandexcloud.net:9091 \
       -t dataproc-topic \
       -k key \
       -X security.protocol=SASL_SSL \
       -X sasl.mechanism=SCRAM-SHA-512 \
       -X sasl.username="dataprocadm" \
       -X sasl.password="jiegaing1iJohcu1" \
       -X ssl.ca.location=/usr/local/share/ca-certificates/Yandex/YandexInternalRootCA.crt -Z

