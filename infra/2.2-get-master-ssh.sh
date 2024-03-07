#!/bin/bash

set -eu

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.2-dataproc-config.env

# Получаем fqdn master-ноды кластера DataProc
export DATAPROC_MASTER_NODE_FQDN=$(yc dataproc cluster list-hosts --name ${DATAPROC_CLUSTER_NAME} --format json | jq -r '.[] | select(.role == "MASTERNODE") | .name')

# Добавляем fingerprint хоста в ~/.ssh/known_hosts
if [ -f ~/.ssh/known_hosts ]; then
  ssh-keygen -R $DATAPROC_MASTER_NODE_FQDN >/dev/null
fi
ssh-keyscan -H $DATAPROC_MASTER_NODE_FQDN 2>/dev/null >> ~/.ssh/known_hosts

# Печатаем команду для подключения к master-ноде dataproc
echo "ssh -i $SSH_KEY_FILE ubuntu@$DATAPROC_MASTER_NODE_FQDN"
