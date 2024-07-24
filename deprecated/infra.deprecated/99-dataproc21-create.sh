#!/bin/bash

yc dataproc cluster create test2-course-21 \
  --zone=ru-central1-a \
  --service-account-name=dataproc-sa-test \
  --bucket=test2-dataproc-21 \
  --version=2.1 \
  --services=SPARK,YARN,LIVY \
  --ssh-public-keys-file=./temp/id_ed25519.pub \
  --security-group-ids=enpriglh71kh2kbahte6 \
  --subcluster name=master,role=masternode,resource-preset=s3-c2-m8,disk-type=network-ssd,disk-size=50,subnet-name=dataproc-ru-central1-a,assign-public-ip=false \
  --subcluster name=compute,role=computenode,resource-preset=s3-c2-m8,disk-type=network-ssd,disk-size=50,subnet-name=dataproc-ru-central1-a,hosts-count=1,assign-public-ip=false,  \
  --deletion-protection=false \
  --ui-proxy=true \
  --property livy:livy.spark.deploy-mode=client