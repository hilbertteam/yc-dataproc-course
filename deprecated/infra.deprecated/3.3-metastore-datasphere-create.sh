#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/3.3-metastore-config.env

###
# Service Account
###
# Создаем сервисный аккаунт datasphere-sa
yc iam service-account get $DATASPHERE_SA_NAME || yc iam service-account create $DATASPHERE_SA_NAME

# Получаем id сервисного аккаунта datasphere-sa
export DATASPHERE_SA_ID=$(yc iam service-account get $DATASPHERE_SA_NAME --format json | jq -r ".id")
# Назначаем сервисному аккаунту роли
yc resource-manager folder add-access-binding dataproc \
  --role vpc.user \
  --subject serviceAccount:$DATASPHERE_SA_ID
yc resource-manager folder add-access-binding dataproc \
  --role dataproc.agent \
  --subject serviceAccount:$DATASPHERE_SA_ID

###
# DataSphere
###
# Готовим providers.tf
cd ./terraform
./prepare.sh
cd -
# Создаем DataSphere
cd ./terraform/datasphere
terraform init -upgrade && terraform plan && terraform apply -auto-approve
cd -