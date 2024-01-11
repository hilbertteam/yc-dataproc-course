#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/5.2-kafka-config.env


###
# Kafka
###
# Получаем ID сети
export VPC_NETWORK_ID=$(yc vpc network get $VPC_NETWORK_NAME | grep "^id:" | awk '{ print $2 }')

# Удаляем кластер
yc managed-kafka cluster delete $KAFKA_CLUSTER_NAME

# Удаляем правила группы безопасности
# yc vpc security-group get $KAFKA_SG_NAME | yq ".rules[].id" | xargs -I{} yc vpc security-group update-rules $KAFKA_SG_NAME --delete-rule-id {}
# Удаляем группу безопасности
yc vpc security-group delete $KAFKA_SG_NAME
