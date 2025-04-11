#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/7.2-clickhouse-config.env

#########
# Infra #
#########

###
# dataproc cluster
###
# Инициализируем переменные
source `dirname "$(realpath $0)"`/terraform/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/7.2-clickhouse/tf.env

# Инициализируем провайдера
cd `dirname "$(realpath $0)"`/terraform/lessons/7.2-clickhouse
terraform init -upgrade

# Дестрой
terraform destroy
