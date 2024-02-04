#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env


###
# S3 buckets
###

# Удаляем бакет который будет использоваться для хранения логов и другой диагностической информации о работе кластера
yc storage bucket delete \
  --name $S3_BUCKET_INFRA
# Удаляем бакет который будет хранить в себе PySpark-задания и их зависимости
yc storage bucket delete \
  --name $S3_BUCKET_TASKS


###
# Service Account
###

# Удаляем сервисный аккаунт
yc iam service-account delete $DATAPROC_SA_NAME


###
# nat gateway
###

# Отвязываем таблицу маршрутизации от подсети
yc vpc subnet update $VPC_SUBNET_NAME \
  --disassociate-route-table

# Удаляем таблицу маршрутизации
yc vpc route-table delete $ROUTE_TABLE_NAME

# Удаляем nat gateway
yc vpc gateway delete \
   --name $NAT_GATEWAY_NAME


###
# ssh
###
# Удаляем пару ssh-ключей
rm -f ${SSH_KEY_FILE}
rm ${SSH_KEY_FILE}.pub
