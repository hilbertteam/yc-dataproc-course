#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/3.5-deltalake-config.env

#########
# Infra #
#########

###
# dataproc cluster
###
# Инициализируем переменные
source `dirname "$(realpath $0)"`/terraform/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/3.5-deltalake/tf.env

# Инициализируем провайдера
cd `dirname "$(realpath $0)"`/terraform/lessons/3.5-deltalake
terraform init -upgrade

# Дестрой
terraform destroy
