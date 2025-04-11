#!/bin/bash

# source `dirname "$(realpath $0)"`/../0-common-config.env

export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

# export YC_ORGANIZATION_ID=""
# export YC_BILLING_ACCOUNT_ID=""
# Считываем значения переменных, используются YC_ORGANIZATION_ID и YC_BILLING_ACCOUNT_ID
source `dirname "$(realpath $0)"`/../0-common-config.env

envsubst < ../templates/terraform/providers.tf > ./datasphere/gen-providers.tf
envsubst < ../templates/terraform/variables.tf > ./datasphere/gen-variables.tf
