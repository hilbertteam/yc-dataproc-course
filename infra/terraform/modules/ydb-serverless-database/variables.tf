variable "name" {
  type = string
  description = "(Required) Name for the Yandex Database serverless cluster"
}

variable "folder_id" {
  type = string
  description = "(Optional) ID of the folder that the Yandex Database serverless cluster belongs to. It will be deduced from provider configuration if not set explicitly"
  default = null
}

variable "description" {
  type = string
  description = "(Optional) A description for the Yandex Database serverless cluster"
  default = null
}

variable "location_id" {
  type = string
  description = "(Optional) Location ID for the Yandex Database serverless cluster"
  default = null
}

variable "labels" {
  type = map(string)
  description = "(Optional) A set of key/value label pairs to assign to the Yandex Database serverless cluster"
  default = {}
}

variable "deletion_protection" {
  type = bool
  description = "(Optional) Inhibits deletion of the database. Can be either true or false"
  default = false
}
