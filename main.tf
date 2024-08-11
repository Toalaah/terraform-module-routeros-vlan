locals {
  has_address = var.cidr != null
  # Need to add bridge as a tagged interface if we assign an address.
  tagged_vlan_interfaces = concat(
    var.tagged_interfaces,
    local.has_address ? [var.bridge] : []
  )
  network      = try(cidrhost(var.cidr, 0), null)
  network_cidr = try("${local.network}/${local.netmask_num_bits}", null)
  netmask_num_bits = try(sum(
    [for x in split(".", cidrnetmask(var.cidr)) : 8 - log(256 - parseint(x, 10), 2)]
  ), null)
  gateway = try(split("/", var.cidr)[0], null)

  identifier = format("VLAN%d-%s", var.vlan_id, var.name)
  comment    = "Terraform-managed"
}

resource "routeros_interface_vlan" "this" {
  # The actual virtual interface is only needed when assigning an address / DHCP server to this VLAN.
  count = var.cidr == null ? 0 : 1

  vlan_id   = var.vlan_id
  interface = var.bridge
  name      = local.identifier
  comment   = local.comment
}

resource "routeros_ip_address" "this" {
  count     = var.cidr == null ? 0 : 1
  address   = var.cidr
  interface = routeros_interface_vlan.this[0].name
  comment   = local.comment
}

# Ensure that untagged interfaces are correctly assigned the respective VLAN ID.
resource "routeros_interface_bridge_port" "untagged_interfaces" {
  for_each = toset(var.untagged_interfaces)

  bridge    = var.bridge
  interface = each.value
  pvid      = var.vlan_id
  # No comment on bridge port resources as we only want to perturb the
  # interfaces's associated bridge and PVID. Other modules may also affect this
  # interface differently, so we want to prevent drift for all properties
  # *except* the vlan ID.
}

# Configure bridge VLAN settings
resource "routeros_interface_bridge_vlan" "vlan_interfaces" {
  vlan_ids = var.vlan_id
  bridge   = var.bridge
  tagged   = local.tagged_vlan_interfaces
  untagged = var.untagged_interfaces
  comment  = local.comment
}

resource "routeros_ip_dhcp_server" "this" {
  count = var.dhcp_enable ? 1 : 0

  interface    = routeros_interface_vlan.this[0].name
  name         = local.identifier
  address_pool = routeros_ip_pool.this[0].name
  lease_time   = var.dhcp_lease_time
  comment      = local.comment
}

resource "routeros_ip_pool" "this" {
  count = var.dhcp_enable ? 1 : 0

  ranges  = var.dhcp_ranges
  name    = local.identifier
  comment = local.comment
}

resource "routeros_ip_dhcp_server_network" "this" {
  count = var.dhcp_enable ? 1 : 0

  address    = local.network_cidr
  gateway    = local.gateway
  dns_server = join(",", var.dhcp_dns_servers)
  comment    = local.comment
}
