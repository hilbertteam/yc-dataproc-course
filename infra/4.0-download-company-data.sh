#!/bin/bash

set -eux

# Download company data files to ../temp/company-data
# These files will be uploaded in bucket S3_BUCKET_TASKS
aws s3 \
    --endpoint-url https://storage.yandexcloud.net \
    --region ru-central1 \
    --no-sign-request \
    sync s3://data-proc-spark-big-data/ ../temp/data \
    --exclude archive.zip