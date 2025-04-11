variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "folder_id" {
  type = string
  description = "(optional) SG folder id"
  default = null
}

variable "name" {
  type        = string
  description = "(optional) SG name"
}

variable "description" {
  type        = string
  description = "(optional) SG description"
  default     = null
}

variable "labels" {
  type        = map(string)
  description = "(optional) Mapping of SG labels"
  default = {
    # "label_name" = "label_value"
  }
}

variable "ingress_rules" {
  type = map(object({
    protocol          = string                       # One of ANY, TCP, UDP, ICMP, IPV6_ICMP.
    description       = optional(string, null)       # Description of the rule.
    labels            = optional(map(string), {})    # Labels to assign to this rule.
    from_port         = optional(number, null)       # Minimum port number.
    to_port           = optional(number, null)       #  Maximum port number.
    port              = optional(number, null)       # Port number (if applied to a single port).
    security_group_id = optional(string, null)       # Target security group ID for this rule.
    predefined_target = optional(string, null)       # Special-purpose targets such as "self_security_group". See docs for possible options.
    v4_cidr_blocks    = optional(list(string), null) # The blocks of IPv4 addresses for this rule.
    v6_cidr_blocks    = optional(list(string), null) # The blocks of IPv6 addresses for this rule. v6_cidr_blocks argument is currently not supported. It will be available in the future.
  }))
  description = "(optional) Ingress rules list"
  default = {
    allow_all = {
      protocol       = "TCP"
      description    = "Allow all"
      from_port      = 0
      to_port        = 65535
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

variable "egress_rules" {
  type = map(object({
    protocol          = string                       # One of ANY, TCP, UDP, ICMP, IPV6_ICMP.
    description       = optional(string, null)       # Description of the rule.
    labels            = optional(map(string), {})    # Labels to assign to this rule.
    from_port         = optional(number, null)       # Minimum port number.
    to_port           = optional(number, null)       #  Maximum port number.
    port              = optional(number, null)       # Port number (if applied to a single port).
    security_group_id = optional(string, null)       # Target security group ID for this rule.
    predefined_target = optional(string, null)       # Special-purpose targets such as "self_security_group". See docs for possible options.
    v4_cidr_blocks    = optional(list(string), null) # The blocks of IPv4 addresses for this rule.
    v6_cidr_blocks    = optional(list(string), null) # The blocks of IPv6 addresses for this rule. v6_cidr_blocks argument is currently not supported. It will be available in the future.
  }))
  description = "(optional) Egress rules list"
  default = {
    allow_all = {
      protocol       = "TCP"
      description    = "Allow all"
      from_port      = 0
      to_port        = 65535
      v4_cidr_blocks = ["0.0.0.0/0"]
    }
  }
}