module "s3-dataproc-delta1-infra" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = var.s3_bucket_dataproc1
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
          "${data.yandex_iam_service_account.dataproc-sa.id}",
          "${data.yandex_iam_service_account.terraform-s3-manager-sa.id}"
        ]
      },
      "Action": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dataproc1}/*",
        "arn:aws:s3:::${var.s3_bucket_dataproc1}"
      ]
    },
    {
      "Action": "*",
      "Condition" : {
        "StringLike" : {
          "aws:referer" : "https://console.yandex.cloud/folders/*/storage/buckets/${var.s3_bucket_dataproc1}*"
        }
      },
      "Effect": "Allow",
      "Principal": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dataproc1}/*",
        "arn:aws:s3:::${var.s3_bucket_dataproc1}"
      ],
      "Sid": "console-statement"
    }
  ]
}
POLICY
}

module "s3-dataproc-delta2-infra" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = var.s3_bucket_dataproc2
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
          "${data.yandex_iam_service_account.dataproc-sa.id}",
          "${data.yandex_iam_service_account.terraform-s3-manager-sa.id}"
        ]
      },
      "Action": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dataproc2}/*",
        "arn:aws:s3:::${var.s3_bucket_dataproc2}"
      ]
    },
    {
      "Action": "*",
      "Condition" : {
        "StringLike" : {
          "aws:referer" : "https://console.yandex.cloud/folders/*/storage/buckets/${var.s3_bucket_dataproc2}*"
        }
      },
      "Effect": "Allow",
      "Principal": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dataproc2}/*",
        "arn:aws:s3:::${var.s3_bucket_dataproc2}"
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

resource "yandex_storage_object" "yc-delta-multi-fatjar" {
  bucket = var.s3_bucket_tasks
  key    = "jars/yc-delta23-multi-dp21-1.2-fatjar.jar"
  source = "${path.module}/../../../jars/yc-delta23-multi-dp21-1.2-fatjar.jar"
  access_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.tf-mgmt-sa-static-key.secret_key
}
