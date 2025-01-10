module "s3-bucket-dags" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = var.s3_bucket_dags
  sa_id     = data.yandex_iam_service_account.terraform-s3-manager-sa.id
  force_destroy = true
  policy    = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "Allow all for ${module.airflow_sa.sa_name}",
      "Effect": "Allow",
      "Principal": {
        "CanonicalUser": [
          "${module.airflow_sa.sa_id}",
          "${data.yandex_iam_service_account.terraform-s3-manager-sa.id}"
        ]
      },
      "Action": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dags}/*",
        "arn:aws:s3:::${var.s3_bucket_dags}"
      ]
    },
    {
      "Action": "*",
      "Condition" : {
        "StringLike" : {
          "aws:referer" : "https://console.yandex.cloud/folders/*/storage/buckets/${var.s3_bucket_dags}*"
        }
      },
      "Effect": "Allow",
      "Principal": "*",
      "Resource": [
        "arn:aws:s3:::${var.s3_bucket_dags}/*",
        "arn:aws:s3:::${var.s3_bucket_dags}"
      ],
      "Sid": "console-statement"
    }
  ]
}
POLICY
}