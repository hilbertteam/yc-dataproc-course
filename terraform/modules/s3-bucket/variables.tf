variable "bucket" {
  type = string
  description = "s3 bucket name"
}

variable "folder_id" {
  type = string
  description = "(optional) bucket folder id"
}

variable "sa_id" {
  type = string
  description = "Service Account ID to manage bucket"
}

variable "policy" {
  type = string
  description = "Bucket policy"
}