#!/bin/bash

PROJECT_DIR=$(dirname "$(realpath $0)")
CSV_ARCHIVE_URL=https://storage.yandexcloud.net/data-proc-spark-big-data/archive.zip
CSV_ARCHIVE_FILE=archive.zip

mkdir -p $PROJECT_DIR/../temp/data
cd $PROJECT_DIR/../temp/data

wget $CSV_ARCHIVE_URL
unzip -o archive.zip
rm archive.zip
ls -la

cd $PROJECT_DIR