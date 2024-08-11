variable "name" {
  type        = string
  description = "Identifier for this VLAN."
}

variable "vlan_id" {
  type        = string
  description = "VLAN ID to assign to this subnet."

  validation {
    condition     = var.vlan_id != 1
    error_message = "VLAN ID should not be 1 (reserved)"
  }

  validation {
    condition     = var.vlan_id > 1
    error_message = "VLAN ID should be positive"
  }
}

variable "cidr" {
  type        = string
  description = <<-EOF
    Assigns an address to the created VLAN interface. Set to null (default) to
    disable creating an address on the router / switch. When enabling a DHCP
    server, this address is used as a  gateway and must not be null. Address
    must be given in CIDR notation.

    Example: `"172.16.10.1/24"`
  EOF
  default     = null
}

variable "bridge" {
  type        = string
  nullable    = false
  description = "Bridge interface to attach this VLAN to. Ensure that the bridge has vlan filtering enabled."
}

variable "dhcp_enable" {
  type        = bool
  default     = false
  nullable    = false
  description = "Whether to enable creation of a DHCP server for this VLAN. Requires `gateway` to be set."
}

variable "dhcp_ranges" {
  type        = list(string)
  description = <<-EOF
    List of address ranges to allocate for DHCP. Has no effect if `enable_dhcp` is false.
 (e.g. )

    Example: `["192.168.88.100-192.168.88.200", "192.168.88.50-192.168.88.60"]`
  EOF
  default     = null
}

variable "dhcp_dns_servers" {
  type        = list(string)
  description = <<-EOF
    List of DNS servers to advertise in DHCP offers. Has no effect if `enable_dhcp` is false.

    Example: `["8.8.8.8", "1.1.1.1"]`
  EOF
  nullable    = false
  default     = []
}

variable "dhcp_lease_time" {
  type        = string
  description = <<-EOF
    Lease time of DHCP offers. Has no effect if `enable_dhcp` is false.

    Example: `"60m"`
  EOF
  nullable    = false
  default     = "30m"
}

variable "tagged_interfaces" {
  type = list(string)
  # TODO: maybe we can detect whether an interface is already added to the
  # bridge via a datasource, and then handle accordingly.
  description = <<-EOF
    List of tagged interfaces / ports to assign to this VLAN. Any untagged
    frames passing through these interfaces which are dropped. Tagged
    interfaces must be *manually* added to the bridge by the user.

    Example: `["ether1", "ether2"]`
  EOF
  nullable    = false
  default     = []
}

variable "untagged_interfaces" {
  type        = list(string)
  description = <<-EOF
    List of untagged interfaces / ports to assign to this VLAN. Any traffic
    passing through these interfaces is implicitly assigned the associated VLAN
    ID, even if frames are untagged. Untagged interfaces are automatically
    added to the bridge and assigned the respective VLAN ID.

    Example: `["ether1", "ether2"]`
  EOF
  nullable    = false
  default     = []
}
