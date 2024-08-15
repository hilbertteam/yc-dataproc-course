#!/bin/bash

set -ux

# Считываем значения переменных
source `dirname "$(realpath $0)"`/0-common-config.env

#########
# Infra #
#########

###
# ssh
###
# Создаем пару ssh-ключей если не была создана ранее
test -f "$SSH_KEY_FILE" || ssh-keygen -t ed25519 -f $SSH_KEY_FILE -q -N ""
chmod 0400 $SSH_KEY_FILE

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

# План и апплай
terraform plan
terraform apply
