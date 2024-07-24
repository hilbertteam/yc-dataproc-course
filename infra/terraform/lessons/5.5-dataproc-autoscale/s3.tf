module "s3-dataproc-infra" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = var.s3_bucket_dataproc
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
          "${module.terraform-s3-manager-sa.sa_id}"
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