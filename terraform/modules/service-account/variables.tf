variable "name" {
    type = string
    description = "SA name"
}

variable "folder_id" {
  type = string
  description = "(optional) SA folder id"
  default = null
}

variable "folder_iam_roles" {
  type = list(string)
  description = "(optional) List of roles to grant for serviceaccount on folder"
  default = []
}

variable "description" {
    type = string
    description = "(optional) SA description"
    default = null
}

variable "static_access_keys" {
  type = map(string)
  description = "(optional) mapping of static access keys"
  default = {}
}