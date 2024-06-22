locals {
  s3_infra_bucket_name = "yc-dataproc-infra-21"
}

module "s3-dataproc-infra" {
  source    = "../../modules/s3-bucket"
  folder_id = var.yc_folder_id
  bucket    = local.s3_infra_bucket_name
  sa_id     = module.terraform-s3-manager-sa.sa_id
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
        "arn:aws:s3:::${local.s3_infra_bucket_name}/*",
        "arn:aws:s3:::${local.s3_infra_bucket_name}"
      ]
    }
  ]
}
POLICY
}