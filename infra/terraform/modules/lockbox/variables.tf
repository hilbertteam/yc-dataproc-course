variable "name" {
  type        = string
  description = "(Optional) Name for the Yandex Cloud Lockbox secret"
  default     = null
}

variable "folder_id" {
  type        = string
  description = "(Optional) ID of the folder that the Yandex Cloud Lockbox secret belongs to"
  default     = null
}

variable "description" {
  type        = string
  description = "(Optional) A description for the Yandex Cloud Lockbox secret"
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "(Optional) A set of key/value label pairs to assign to the Yandex Cloud Lockbox secret"
  default     = {}
}

variable "deletion_protection" {
  type        = bool
  description = "(Optional) Whether the Yandex Cloud Lockbox secret is protected from deletion"
  default     = false
}

variable "kms_key_id" {
  type        = string
  description = "(Optional) The KMS key used to encrypt the Yandex Cloud Lockbox secret"
  default     = null
}

variable "secret_version_text_entries" {
  type = map(object({
    key = string
    text_value = string
  }))
  description = "Secret version entries with text values"
  default = {}
  # {
  #   secret1 = {
  #     key = "secret_key"
  #     text_value = "secret_text_value"
  #   }
  # }
}

variable "secret_version_command_entries" {
  type = map(object({
    key = string
    args = list(string)
    env = map(string)
  }))
  description = "Secret version entries with command values"
  default = {}
  # {
  #   secret1 = {
  #     key = "gen_secret.sh"
  #     args = [ "--length", "14" ]
  #     env = {
  #       "ENV_VAR1" = "value1"
  #       "ENV_VAR2" = "value2"
  #     }
  #   }
  # }
}