resource "yandex_vpc_security_group_rule" "ingress" {
  for_each = var.ingress_rules

  security_group_binding = yandex_vpc_security_group.sg.id
  direction              = "ingress"
  protocol               = each.value.protocol
  description            = each.value.description
  labels                 = each.value.labels
  from_port              = each.value.from_port
  to_port                = each.value.to_port
  port                   = each.value.port
  security_group_id      = each.value.security_group_id
  predefined_target      = each.value.predefined_target
  v4_cidr_blocks         = each.value.v4_cidr_blocks
  v6_cidr_blocks         = each.value.v6_cidr_blocks
}

resource "yandex_vpc_security_group_rule" "egress" {
  for_each = var.egress_rules

  security_group_binding = yandex_vpc_security_group.sg.id
  direction              = "egress"
  protocol               = each.value.protocol
  description            = each.value.description
  labels                 = each.value.labels
  from_port              = each.value.from_port
  to_port                = each.value.to_port
  port                   = each.value.port
  security_group_id      = each.value.security_group_id
  predefined_target      = each.value.predefined_target
  v4_cidr_blocks         = each.value.v4_cidr_blocks
  v6_cidr_blocks         = each.value.v6_cidr_blocks
}