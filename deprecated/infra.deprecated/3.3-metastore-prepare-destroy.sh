#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/3.3-metastore-config.env

###
# Secority Group
###
# Удаляем Группу безопасности и правила в ней
yc vpc security-group delete $DATAPROC_SG_NAME
yc vpc security-group delete $METASTORE_SG_NAME

###
# s3
###
# Удаляем бакет который будет хранить данные
yc storage bucket delete \
  --name $S3_BUCKET_DATA