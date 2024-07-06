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

# variable "sa_name" {
#   type = string
#   description = "Name of the service account to manage s3 bucket"
#   default = "terraform-s3-manager-sa"
# }

# variable "sa_description" {
#   type = string
#   description = "descsa_description of the service account to manage s3 bucket"
#   default = "terraform s3 manager sa"
# }

variable "policy" {
  type = string
  description = "Bucket policy"
}

variable "tags" {
  type = map(string)
  description = "s3 bucket tags"
  default = {
    managed_by = "terraform"
  }
}

variable "max_size" {
  type = number
  description = "Max bucket size, Gb"
  default = 0  # unlimited
}

variable "default_storage_class" {
  type = string
  description = "bucket default storage class"
  default = "STANDARD"
}

variable "versioning_enabled" {
  type = bool
  description = "Enable bucket versioning"
  default = false
}

variable "force_destroy" {
  type = bool
  description = "(Optional, Default: false) A boolean that indicates all objects should be deleted from the bucket so that the bucket can be destroyed without error. These objects are not recoverable."
  default = false
}