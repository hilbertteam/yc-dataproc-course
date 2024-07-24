#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/3.3-metastore-config.env

###
# S3
###
# Получаем id сервисного аккаунта dataproc-sa
export DATAPROC_SA_ID=$(yc iam service-account get $DATAPROC_SA_NAME --format json | jq -r ".id")
# получаем id сервисного аккаунта toolbox-sa
export TOOLBOX_SA_ID=$(yc iam service-account get $TOOLBOX_SA_NAME --format json | jq -r ".id")
# Создание бакета который будет хранить в себе данные
yc storage bucket get $S3_BUCKET_DATA || yc storage bucket create \
  --name $S3_BUCKET_DATA
# Генерируем json-файл с политиками из шаблона
# DATA
export S3_BUCKET_NAME="${S3_BUCKET_DATA}"
envsubst < templates/s3-sa-policy.json > ./temp/s3-sa-policy.json
# Назначаем сервисному аккаунту policy на бакет
yc storage bucket update --name $S3_BUCKET_NAME --policy-from-file ./temp/s3-sa-policy.json


###
# Security Group
###
# Получаем ID сети
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME --format json | jq -r ".id")

# # Создаем группу безопасности для Metastore
yc vpc security-group get $METASTORE_SG_NAME 2>/dev/null || yc vpc security-group create \
  --name $METASTORE_SG_NAME \
  --rule "direction=egress,port=any,protocol=any,v4-cidrs=[0.0.0.0/0],description='MetaStore'" \
  --rule "direction=ingress,from-port=30000,to-port=32767,protocol=any,v4-cidrs=[0.0.0.0/0],description='MetaStore'" \
  --rule "direction=ingress,port=10256,protocol=any,predefined=loadbalancer_healthchecks,description='MetaStore'" \
  --network-id $VPC_NETWORK_ID
# Получаем идентификатор группы безопасности Metastore
export METASTORE_SG_ID=$(yc vpc security-group get $METASTORE_SG_NAME --format json | jq -r ".id")


# Создаем группу безопасности для DataSphere
yc vpc security-group get $DATASPHERE_SG_NAME 2>/dev/null || yc vpc security-group create \
  --name $DATASPHERE_SG_NAME \
  --rule "direction=egress,port=any,protocol=any,v4-cidrs=[0.0.0.0/0]" \
  --network-id $VPC_NETWORK_ID
# Получаем идентификатор группы безопасности DataSphere
export DATASPHERE_SG_ID=$(yc vpc security-group get $DATASPHERE_SG_NAME --format json | jq -r ".id")


# Получаем идентификатор группы безопасности yc-toolbox
export TOOLBOX_SG_ID=$(yc vpc security-group get $TOOLBOX_SG_NAME --format json | jq -r ".id")
# Создаем Группу безопасности dataproc-sg и правила в ней
yc vpc security-group get $DATAPROC_SG_NAME 2>/dev/null || yc vpc security-group create \
  --name $DATAPROC_SG_NAME \
  --rule "direction=ingress,port=any,protocol=any,predefined=self_security_group" \
  --rule "direction=ingress,port=any,protocol=any,security-group-id=$DATASPHERE_SG_ID" \
  --rule "direction=ingress,port=any,protocol=any,security-group-id=$METASTORE_SG_ID" \
  --rule "direction=ingress,port=22,protocol=tcp,security-group-id=$TOOLBOX_SG_ID" \
  --rule "direction=egress,port=any,protocol=any,predefined=self_security_group" \
  --rule "direction=egress,port=123,protocol=udp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=egress,port=80,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=egress,port=443,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=egress,port=9083,protocol=any,v4-cidrs=[0.0.0.0/0],description='Allow 9083 to metastore'" \
  --rule "direction=egress,port=any,protocol=any,security-group-id=$METASTORE_SG_ID" \
  --network-id $VPC_NETWORK_ID
# Получаем идентификатор группы безопасности dataproc-sg
export DATAPROC_SG_ID=$(yc vpc security-group get $DATAPROC_SG_NAME --format json | jq -r ".id")

# Добавляем в metastore-sg правило разрешающее весь трафик от dataproc-sg
yc vpc security-group update-rules \
  --name $METASTORE_SG_NAME \
  --add-rule "direction=ingress,port=any,protocol=any,security-group-id=$DATAPROC_SG_ID,description='Allow all from $DATAPROC_SG_NAME'" \
  --add-rule "direction=egress,port=any,protocol=any,security-group-id=$DATAPROC_SG_ID,description='Allow all to $DATAPROC_SG_NAME'"