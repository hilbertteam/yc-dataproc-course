#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env
source `dirname "$(realpath $0)"`/5.5-dataproc-autoscale-config.env

#########
# Infra #
#########

###
# dataproc cluster
###
# Инициализируем переменные
source `dirname "$(realpath $0)"`/terraform/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/tf.env
source `dirname "$(realpath $0)"`/terraform/lessons/5.5-dataproc-autoscale/tf.env

# Инициализируем провайдера
cd `dirname "$(realpath $0)"`/terraform/lessons/5.5-dataproc-autoscale
terraform init -upgrade

# Дестрой
terraform destroy
