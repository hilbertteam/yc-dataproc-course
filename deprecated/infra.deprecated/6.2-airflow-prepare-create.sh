#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/6.2-airflow-config.env

# Получаем ID сети
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME | grep "^id:" | awk '{ print $2 }')

# Создаем группу безопасности
yc vpc security-group create \
  --name $AIRFLOW_SG_NAME \
  --rule "direction=ingress,port=80,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=ingress,port=443,protocol=tcp,v4-cidrs=[0.0.0.0/0]" \
  --rule "direction=egress,port=any,protocol=any,v4-cidrs=[0.0.0.0/0]" \
  --network-id $VPC_NETWORK_ID

###
# SA
###
# Создание сервисного аккаунта для Airflow
yc iam service-account create --name $AIRFLOW_SA_NAME
# получаем id сервисного аккаунта airflow-sa
export AIRFLOW_SA_ID=$(yc iam service-account get $AIRFLOW_SA_NAME --format json | jq -r ".id")
# Присваиваем роль сервисному аккаунту (требуется для работы Yandex Managed Service for Apache Airflow)
yc resource-manager folder add-access-binding \
  --name dataproc \
  --role managed-airflow.integrationProvider \
  --subject serviceAccount:$AIRFLOW_SA_ID

###
# S3
###
# Создание бакета который будет хранить в себе DAG-файлы
yc storage bucket get $S3_BUCKET_DAGS || yc storage bucket create \
  --name $S3_BUCKET_DAGS
# получаем id сервисного аккаунта airflow-sa
export AIRFLOW_SA_ID=$(yc iam service-account get $AIRFLOW_SA_NAME --format json | jq -r ".id")
# получаем id сервисного аккаунта toolbox-sa
export TOOLBOX_SA_ID=$(yc iam service-account get $TOOLBOX_SA_NAME --format json | jq -r ".id")
# Генерируем json-файл с политиками из шаблона
# DATA
export S3_BUCKET_NAME="${S3_BUCKET_DAGS}"
envsubst < templates/s3-dags-sa-policy.json > ./temp/s3-dags-sa-policy.json
# Назначаем сервисному аккаунту policy на бакет
yc storage bucket update --name $S3_BUCKET_NAME --policy-from-file ./temp/s3-dags-sa-policy.json

# Генерируем статический ключ для сервисного аккаунта
yc iam access-key create --service-account-name $AIRFLOW_SA_NAME \
  --description "Для доступа Airflow к s3 бакету с DAG-файлами"
  