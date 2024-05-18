#!/bin/bash

# source `dirname "$(realpath $0)"`/../0-common-config.env

export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)

envsubst < ../templates/terraform/providers.tf > ./datasphere/gen-providers.tf
