#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.2-dataproc-config.env


###
# DataProc Cluster
###
# Получаем ID группы безопасности toolbox-sg
export TOOLBOX_SG_ID=$(yc vpc security-group get $TOOLBOX_SG_NAME | grep "^id:" | awk '{ print $2 }')
# Отвязываем Группу безопасности dataproc-sg от виртуальной машины yc-toolbox
yc compute instance update-network-interface \
  --name $TOOLBOX_NAME \
  --network-interface-index 0 \
  --security-group-id $TOOLBOX_SG_ID
# Удаляем dataproc кластер
yc dataproc cluster delete $DATAPORC_CLUSTER_NAME


###
# Secority Group
###
# Удаляем Группу безопасности и правила в ней
yc vpc security-group delete $DATAPROC_SG_NAME
