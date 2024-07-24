#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.2-dataproc-config.env
source `dirname "$(realpath $0)"`/2.5-logging-config.env


###
# YDB
###
yc ydb database get $LOG_YDB_NAME 2>/dev/null || yc ydb database create \
  --name $LOG_YDB_NAME \
  --fixed-size $LOG_YDB_SIZE \
  --serverless

# Ждем 2с иначе Data Stream её не увидит ^_^
sleep 2

###
# Data Stream (aws kinesis)
###
# Создаем статический ключ для сервисного аккаунта привязанного к yc-toolbox
# для настройки утилиты aws для дальнейшей настройки Yandex DataStream
test -f temp/aws-cli-static.yml || yc iam access-key create \
  --service-account-name $TOOLBOX_SA_NAME \
  --description "aws cli $(date +'%Y-%m-%d %H:%M:%S')" > temp/aws-cli-static.yml
# Настраиваем aws cli
export AWS_ACCESS_KEY_ID=$(yq '.access_key.key_id'  < temp/aws-cli-static.yml)
export AWS_SECRET_ACCESS_KEY=$(yq '.secret' < temp/aws-cli-static.yml)

export YC_CLOUD_ID=$(yc config get cloud-id)
export LOG_YDB_ID=$(yc ydb database get --name ${LOG_YDB_NAME} --format json | jq -r ".id")

# aws kinesis describe-stream \
#   --endpoint https://yds.serverless.yandexcloud.net \
#   --stream-name /${AWS_REGION}/${YC_CLOUD_ID}/${LOG_YDB_ID}/${LOG_DATASTREAM_NAME}

# Создаем поток данных
AWS_PAGER="" aws kinesis describe-stream \
  --endpoint https://yds.serverless.yandexcloud.net \
  --stream-name /${AWS_REGION}/${YC_CLOUD_ID}/${LOG_YDB_ID}/${LOG_DATASTREAM_NAME} || \
  aws kinesis create-stream \
  --endpoint https://yds.serverless.yandexcloud.net \
  --stream-name /${AWS_REGION}/${YC_CLOUD_ID}/${LOG_YDB_ID}/${LOG_DATASTREAM_NAME} \
  --shard-count 1

aws kinesis wait stream-exists \
  --endpoint https://yds.serverless.yandexcloud.net \
  --stream-name /${AWS_REGION}/${YC_CLOUD_ID}/${LOG_YDB_ID}/${LOG_DATASTREAM_NAME}

###
# log group
###

# Создаем группу логирования
yc logging group get $LOG_GROUP_NAME 2>/dev/null || yc logging group create \
  --name $LOG_GROUP_NAME \
  --retention-period $LOG_GROUP_RETENTION_PERIOD \
  --data-stream /${AWS_REGION}/${YC_CLOUD_ID}/${LOG_YDB_ID}/${LOG_DATASTREAM_NAME}


###
# DataProc
###
# Получаем ID лог-группы
export LOG_GROUP_ID=$(yc logging group get $LOG_GROUP_NAME --format json | jq -r ".id")
# Назначаем лог-группу для кластера DataProc
yc dataproc cluster update $DATAPROC_CLUSTER_NAME \
  --log-group-id $LOG_GROUP_ID
