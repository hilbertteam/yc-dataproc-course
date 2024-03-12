#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env

#########
# Infra #
#########

###
# Service Account
###
# Создаем сервисный аккаунт
yc iam service-account create $DATAPROC_SA_NAME

# Получаем id сервисного аккаунта dataproc-sa
export DATAPROC_SA_ID=$(yc iam service-account get $DATAPROC_SA_NAME --format json | jq -r ".id")
# Назначаем сервисному аккаунту роли editor и dataproc.agent (необходимо для DataProc)
yc resource-manager folder add-access-binding dataproc \
  --role editor \
  --subject serviceAccount:$DATAPROC_SA_ID
yc resource-manager folder add-access-binding dataproc \
  --role dataproc.agent \
  --subject serviceAccount:$DATAPROC_SA_ID


###
# S3 buckets
###

# Создание бакета который будет использоваться для хранения логов и другой диагностической информации о работе кластера
yc storage bucket create \
  --name $S3_BUCKET_INFRA
# Создание бакета который будет хранить в себе PySpark-задания и их зависимости
yc storage bucket create \
  --name $S3_BUCKET_TASKS

# получаем id сервисного аккаунта toolbox-sa
export TOOLBOX_SA_ID=$(yc iam service-account get $TOOLBOX_SA_NAME --format json | jq -r ".id")

# Генерируем json-файл с политиками из шаблона
# INFRA
export S3_BUCKET_NAME="${S3_BUCKET_INFRA}"
envsubst < templates/s3-sa-policy.json > ./temp/s3-sa-policy.json
yc storage bucket update --name $S3_BUCKET_NAME --policy-from-file ./temp/s3-sa-policy.json
# TASKS
export S3_BUCKET_NAME="${S3_BUCKET_TASKS}"
envsubst < templates/s3-sa-policy.json > ./temp/s3-sa-policy.json
# Назначаем сервисному аккаунту ACL на бакеты
yc storage bucket update --name $S3_BUCKET_NAME --policy-from-file ./temp/s3-sa-policy.json

###
# nat gateway
###
# Создаем nat gateway
yc vpc gateway get --name $NAT_GATEWAY_NAME 2>/dev/null || yc vpc gateway create \
   --name $NAT_GATEWAY_NAME
# Получаем id nat gateway
export NAT_GATEWAY_ID=$(yc vpc gateway get --name $NAT_GATEWAY_NAME --format json | jq -r ".id")

# Создаем таблицу маршрутизации
yc vpc route-table create $ROUTE_TABLE_NAME \
   --network-name=$VPC_NETWORK_NAME \
   --route destination=0.0.0.0/0,gateway-id=$NAT_GATEWAY_ID
# Привязваем таблицу маршрутизации к подсети
yc vpc subnet update $VPC_SUBNET_NAME \
   --route-table-name=$ROUTE_TABLE_NAME


###
# ssh
###
# Создаем пару ssh-ключей если не была создана ранее
test -f "$SSH_KEY_FILE" || ssh-keygen -t ed25519 -f $SSH_KEY_FILE -q -N ""
chmod 0400 $SSH_KEY_FILE


###
# toolbox sg
###
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME --format json | jq -r ".id")
yc vpc security-group get $TOOLBOX_SG_NAME || yc vpc security-group create \
  --name $TOOLBOX_SG_NAME \
  --network-id $VPC_NETWORK_ID \
  --rule "direction=egress,port=any,protocol=any,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=ingress,port=22,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=ingress,port=8080,protocol=tcp,v4-cidrs=[0.0.0.0/0]"
export TOOLBOX_SG_ID=$(yc vpc security-group get $TOOLBOX_SG_NAME --format json | jq -r ".id")
yc compute instance get $TOOLBOX_NAME && yc compute instance update-network-interface $TOOLBOX_NAME --network-interface-index	0 \
  --security-group-id	$TOOLBOX_SG_ID
