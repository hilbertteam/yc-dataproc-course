#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.3-dataproc-config.env


###
# DataProc Cluster
###

# Удаляем dataproc кластер
yc dataproc cluster delete $DATAPROC_CLUSTER_NAME

# # Удаляем сервисный аккаунт
# yc iam service-account delete $DATAPROC_SA_NAME