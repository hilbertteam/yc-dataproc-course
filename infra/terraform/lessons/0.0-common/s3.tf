module "s3-bucket-data" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = var.s3_bucket_data
  sa_id     = module.terraform-s3-manager-sa.sa_id
  force_destroy = true
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow all for ${module.dataproc-sa.sa_name}",
      "Effect": "Allow",
      "Principal": {
        "CanonicalUser": [
          "${module.dataproc-sa.sa_id}",
          "${module.datasphere-sa.sa_id}",
          "${module.terraform-s3-manager-sa.sa_id}"
        ]
      },
      "Action": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_data}/*",
        "arn:aws:s3:::${var.s3_bucket_data}"
      ]
    },
    {
      "Action": "*",
      "Condition" : {
        "StringLike" : {
          "aws:referer" : "https://console.yandex.cloud/folders/*/storage/buckets/${var.s3_bucket_data}*"
        }
      },
      "Effect": "Allow",
      "Principal": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_data}/*",
        "arn:aws:s3:::${var.s3_bucket_data}"
      ],
      "Sid": "console-statement"
    }
  ]
}
POLICY
}

module "s3-bucket-tasks" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = var.s3_bucket_tasks
  sa_id     = module.terraform-s3-manager-sa.sa_id
  force_destroy = true
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow all for ${module.dataproc-sa.sa_name}",
      "Effect": "Allow",
      "Principal": {
        "CanonicalUser": [
          "${module.dataproc-sa.sa_id}",
          "${module.datasphere-sa.sa_id}",
          "${module.airflow-sa.sa_id}",
          "${module.terraform-s3-manager-sa.sa_id}",
          "${data.yandex_iam_service_account.toolbox-sa.id}"
        ]
      },
      "Action": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_tasks}/*",
        "arn:aws:s3:::${var.s3_bucket_tasks}"
      ]
    },
    {
      "Action": "*",
      "Condition" : {
        "StringLike" : {
          "aws:referer" : "https://console.yandex.cloud/folders/*/storage/buckets/${var.s3_bucket_tasks}*"
        }
      },
      "Effect": "Allow",
      "Principal": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_tasks}/*",
        "arn:aws:s3:::${var.s3_bucket_tasks}"
      ],
      "Sid": "console-statement"
    }
  ]
}
POLICY
}
