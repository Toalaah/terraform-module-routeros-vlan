output "interface" {
  value       = var.cidr != null ? routeros_interface_vlan.this[0].name : null
  description = "The VLAN interface, if created."
}

output "gateway" {
  value       = var.cidr != null ? local.gateway : null
  description = "The gateway address of the VLAN. Set to `null` if no CIDR was given."
}

output "network" {
  value       = local.network_cidr
  description = "The VLAN network, in CIDR form. This may be used to reference the subnet, for instance in firewall rules."
}

output "name" {
  value       = local.identifier
  description = "The name of the created VLAN."
}
