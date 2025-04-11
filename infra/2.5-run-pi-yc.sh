#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.3-dataproc-config.env

###
# Загружаем файл с заданием в s3 бакет
###
# Создаем статический ключ для сервисного аккаунта привязанного к yc-toolbox
# если не был создан ранее.
# для настройки утилиты aws для работы с Object Storage
test -f `dirname "$(realpath $0)"`/temp/aws-cli-static.yml || yc iam access-key create \
  --service-account-name $TOOLBOX_SA_NAME \
  --description "aws cli $(date +'%Y-%m-%d %H:%M:%S')" > temp/aws-cli-static.yml
# Настраиваем aws cli
export AWS_REGION="ru-central1"
export AWS_ACCESS_KEY_ID=$(yq '.access_key.key_id'  < temp/aws-cli-static.yml)
export AWS_SECRET_ACCESS_KEY=$(yq '.secret' < temp/aws-cli-static.yml)

# Загружаем файл в бакет
aws s3 cp \
  --endpoint-url https://storage.yandexcloud.net \
  `dirname "$(realpath $0)"`/../src/pi/dataproc-pi.py s3://$S3_BUCKET_TASKS/tasks/pi/dataproc-pi.py

# Запускаем задачу в spark
yc dataproc job create-pyspark \
  --name "Calculate Pi" \
  --cluster-name $DATAPROC_CLUSTER_NAME \
  --main-python-file-uri s3a://$S3_BUCKET_TASKS/tasks/pi/dataproc-pi.py
