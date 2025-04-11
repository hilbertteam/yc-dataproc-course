#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env

#########
# Infra #
#########

###
# common infra
###
# Инициализируем переменные
source `dirname "$(realpath $0)"`/terraform/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/0.0-common/tf.env

# Инициализируем провайдера
cd `dirname "$(realpath $0)"`/terraform/lessons/0.0-common
terraform init -upgrade

# Дестрой
terraform destroy
