#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/2.7-datasphere-config.env

#########
# Infra #
#########

###
# dataproc cluster
###
# Инициализируем переменные
source `dirname "$(realpath $0)"`/terraform/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/2.7-datasphere/tf.env

# Инициализируем провайдера
cd `dirname "$(realpath $0)"`/terraform/lessons/2.7-datasphere
terraform init -upgrade

# Дестрой
terraform destroy
