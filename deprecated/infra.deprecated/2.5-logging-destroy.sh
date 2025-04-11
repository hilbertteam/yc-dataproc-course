#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.5-logging-config.env


###
# log group
###

# Удаляем группу логирования
yc logging group get --name $LOG_GROUP_NAME 2>/dev/null && yc logging group delete \
  --name $LOG_GROUP_NAME


###
# Data Stream (aws kinesis)
###
# Задаем значения переменных
export AWS_ACCESS_KEY_ID=$(yq '.access_key.key_id' < temp/aws-cli-static.yml)
export AWS_SECRET_ACCESS_KEY=$(yq '.secret' < temp/aws-cli-static.yml)
export AWS_REGION="ru-central1"

export YC_CLOUD_ID=$(yc config get cloud-id)
export LOG_YDB_ID=$(yc ydb database get --name ${LOG_YDB_NAME} --format json | jq -r ".id")


# Удаляем поток данных
AWS_PAGER="" aws kinesis describe-stream \
  --endpoint https://yds.serverless.yandexcloud.net \
  --stream-name /${AWS_REGION}/${YC_CLOUD_ID}/${LOG_YDB_ID}/${LOG_DATASTREAM_NAME} || \
  aws kinesis delete-stream \
  --endpoint https://yds.serverless.yandexcloud.net \
  --stream-name /${AWS_REGION}/${YC_CLOUD_ID}/${LOG_YDB_ID}/${LOG_DATASTREAM_NAME}


###
# YDB
###
# Удаляем YDB
yc ydb database get $LOG_YDB_NAME 2>/dev/null && yc ydb database delete \
  --name $LOG_YDB_NAME
