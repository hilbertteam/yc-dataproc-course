variable "network_id" {
  type = string
}

variable "cluster_name" {
  type        = string
}

variable "description" {
  type    = string
  default = null
}

variable "environment" {
  type        = string
  default     = "PRODUCTION"
}


variable "resource_preset_id" {
  type        = string
  default     = "s3-c2-m8"
}

variable "disk_size" {
  type        = number
  default     = 100
}

variable "disk_type_id" {
  type        = string
  default     = "network-ssd"
}

variable "database_version" {
  type        = string
  default     = "23.3"
}

variable "labels" {
  type = map(any)
  default = {
    deployment = "terraform"
  }
}

variable "backup_window_start_hours" {
  type        = number
  default     = 0
}

variable "backup_window_start_minutes" {
  type        = number
  default     = 0
}

variable "users" {
  type = list(object({
    name         = string
    password     = string
    permissions  = list(string)
  }))
  description = "Additional users"
  default     = []
}



variable "databases" {
  type        = list(string)
  description = "List of multiple database"
  default     = []
}


variable "shards" {
  type        = list(string)
  default     = []
}

variable "hosts" {
  type = list(object({
    zone             = string
    subnet_id        = string
    assign_public_ip = bool
    shard_name       = optional(string)
  }))
}

variable "zk_hosts" {
  type = list(object({
    zone      = string
    subnet_id = string
  }))
  default     = []
}


variable "zk_resource_preset_id" {
  type    = string
  default = "s2.micro"
}

variable "zk_disk_type_id" {
  type    = string
  default = "network-hdd"
}

variable "zk_disk_size" {
  type        = number
  default     = 10
}


variable "access_web_sql" {
  type    = bool
  default = false
}

variable "access_data_lens" {
  type    = bool
  default = false
}