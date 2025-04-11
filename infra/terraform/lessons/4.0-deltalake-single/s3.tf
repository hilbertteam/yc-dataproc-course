module "s3-dataproc-delta-infra" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = var.s3_bucket_dataproc
  sa_id     = data.yandex_iam_service_account.terraform-s3-manager-sa.id
  force_destroy = true
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow all for ${data.yandex_iam_service_account.dataproc-sa.name}",
      "Effect": "Allow",
      "Principal": {
        "CanonicalUser": [
          "${data.yandex_iam_service_account.dataproc-sa.id}",
          "${data.yandex_iam_service_account.datasphere-sa.id}",
          "${data.yandex_iam_service_account.terraform-s3-manager-sa.id}"
        ]
      },
      "Action": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dataproc}/*",
        "arn:aws:s3:::${var.s3_bucket_dataproc}"
      ]
    },
    {
      "Action": "*",
      "Condition" : {
        "StringLike" : {
          "aws:referer" : "https://console.yandex.cloud/folders/*/storage/buckets/${var.s3_bucket_dataproc}*"
        }
      },
      "Effect": "Allow",
      "Principal": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dataproc}/*",
        "arn:aws:s3:::${var.s3_bucket_dataproc}"
      ],
      "Sid": "console-statement"
    }
  ]
}
POLICY
}

###
# Copy jars to s3_bucket_tasks
###
// Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "tf-mgmt-sa-static-key" {
  service_account_id = data.yandex_iam_service_account.terraform-s3-manager-sa.id
  description        = format("Upload objects to s3 bucket %s", var.s3_bucket_tasks)
}

resource "yandex_storage_object" "delta-core-jar" {
  bucket = var.s3_bucket_tasks
  key    = "jars/delta-core_2.12-2.3.0.jar"
  source = "${path.module}/../../../jars/delta-core_2.12-2.3.0.jar"
  access_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.secret_key
}

resource "yandex_storage_object" "delta-storage-jar" {
  bucket = var.s3_bucket_tasks
  key    = "jars/delta-storage-2.3.0.jar"
  source = "${path.module}/../../../jars/delta-storage-2.3.0.jar"
  access_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.secret_key
}

resource "yandex_storage_object" "company-data" {
  for_each = fileset("${path.module}/../../../../temp/data", "*.csv")

  bucket = var.s3_bucket_tasks
  key    = "data/${each.value}"
  source = "${path.module}/../../../../temp/data/${each.value}"
  # etag makes the file update when it changes; see https://stackoverflow.com/questions/56107258/terraform-upload-file-to-s3-on-every-apply
  # source_hash = filemd5("${path.module}/../../../../temp/data/${each.value}")
  access_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.secret_key
}