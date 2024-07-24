#!/bin/bash



yc dataproc cluster create dataproc-course-21 \
  --zone=ru-central1-a \
  --service-account-name=dataproc-sa \
  --bucket=test-dataproc-21 \
  --version=2.1 \
  --services=SPARK,YARN,LIVY \
  --security-group-ids=enpr20t06p1fchlm2neo \
  --ssh-public-keys-file=./temp/id_ed25519.pub \
  --subcluster name=master,role=masternode,resource-preset=s3-c2-m8,disk-type=network-ssd,disk-size=50,subnet-name=dataproc-ru-central1-a,assign-public-ip=false \
  --subcluster name=compute,role=computenode,resource-preset=s3-c2-m8,disk-type=network-ssd,disk-size=50,subnet-name=dataproc-ru-central1-a,hosts-count=1,assign-public-ip=false \
  --ui-proxy=true \
  --property livy:livy.spark.deploy-mode=client \
  --property spark:spark.hive.metastore.uris=thrift://10.128.0.5:9083 \
  --property spark:spark.sql.hive.metastore.sharedPrefixes=com.amazonaws,ru.yandex.cloud \
  --property spark:spark.sql.catalogImplementation=hive \
  --property spark:spark.sql.warehouse.dir=s3a://yc-dataproc-data/warehouse \
  --property spark:spark.jars=s3a://test-dataproc-21/jars/delta-core_2.12-2.3.0.jar,s3a://test-dataproc-21/jars/delta-storage-2.3.0.jar \
  --property spark:spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension \
  --property spark:spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog \
  --property spark:spark.debug.maxToStringFields=200 \
  --deletion-protection=false
