#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.2-dataproc-config.env

###
# DataProc Cluster
###
# Создаем dataproc кластер
yc dataproc cluster delete $DATAPORC_CLUSTER_NAME


###
# Secority Group
###
# Создаем Группу безопасности и правила в ней
yc vpc security-group delete $DATAPROC_SG_NAME
