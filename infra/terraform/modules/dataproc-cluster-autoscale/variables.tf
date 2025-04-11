variable "name" {
  type        = string
  description = "dataproc cluster name"
}

variable "description" {
  type        = string
  description = "dataproc cluster description"
  default     = null
}

variable "folder_id" {
  type        = string
  description = "dataproc folder_id"
  default     = null
}

variable "service_account_id" {
  type        = string
  description = "dataproc sa id"
}

variable "bucket" {
  type        = string
  description = "dataproc bucket"
}

variable "zone_id" {
  type        = string
  description = "zone id"
  default     = null
}

variable "ui_proxy" {
  type        = bool
  description = "enable ui proxy"
  default     = false
}

variable "deletion_protection" {
  type        = bool
  description = "enable deletion protection"
  default     = false
}

variable "security_group_ids" {
  type        = list(string)
  description = "list of security group ids for cluster nodes"
  default     = []
}

variable "labels" {
  type        = map(string)
  description = "dataproc cluster labels mapping"
  default = {
    # "label_name" = "label_value"
  }
}

variable "version_id" {
  type        = string
  description = "dataproc cluster version id"
  default     = null
}

variable "services" {
  type        = list(string)
  description = "dataproc components list"
  default     = ["yarn", "tez", "spark"]
}

variable "properties" {
  type        = map(any)
  description = "dataproc cluster properties mapping"
  default = {
    # "yarn:yarn.resourcemanager.am.max-attempts" = 5
  }
}

variable "ssh_public_keys" {
  type        = list(string)
  description = "list of ssh public keys"
  default = []
}

variable "subclusters" {
  type = map(object({
    # name = string  # (Required) Name of the Data Proc subcluster.
    role               = string                        # (Required) Role of the subcluster in the Data Proc cluster. One of MASTERNODE, DATANODE, COMPUTENODE
    resource_preset_id = string                        # (Required) The ID of the preset for computational resources available to a host. All available presets are listed in the documentation.
    disk_size          = number                        # (Required) Volume of the storage available to a host, in gigabytes.
    disk_type_id       = optional(string, "network-hdd") # (Optional) Type of the storage of a host. One of network-hdd (default) or network-ssd.    subnet_id = string  # (Required) The ID of the subnet, to which hosts of the subcluster belong. Subnets of all the subclusters must belong to the same VPC network.
    hosts_count        = number                        # (Required) Number of hosts within Data Proc subcluster.
    subnet_id          = string                        # (Required) The ID of the subnet, to which hosts of the subcluster belong. Subnets of all the subclusters must belong to the same VPC network.
    assign_public_ip   = optional(bool, false)         # (Optional) If true then assign public IP addresses to the hosts of the subclusters.
    autoscaling_config = object({
      enabled              = bool
      max_hosts_count      = number
      measurement_duration = number
      warmup_duration      = number
      stabilization_duration = number
      preemptible          = bool
      decommission_timeout = number
      cpu_utilization_target  = optional(number)
    })
  }))
  description = "mapping of subclusters"
  default = {
    # main = {
    #   role = "MASTERNODE"
    #   resource_preset_id = "s2.small"
    #   disk_type_id       = "network-hdd"
    #   disk_size          = 20
    #   hosts_count        = 1
    #   subnet_id = "<subnetwork identifier>"
    #   assign_public_ip   = false
    # }
    # compute = {
    #   role = "COMPUTENODE"
    #   resource_preset_id = "s2.small"
    #   disk_type_id       = "network-hdd"
    #   disk_size          = 20
    #   hosts_count        = 1
    #   subnet_id = "<subnetwork identifier>"
    #   assign_public_ip   = false
    # }
  }
}

variable "enable_autoscaling" {
  description = "Enable autoscaling configuration"
  type        = bool
  default     = false
}

variable "cpu_utilization_target" {
  description = "The target CPU utilization for the autoscaling configuration"
  type        = number
  default     = 0.0
}