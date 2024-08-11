## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_routeros"></a> [routeros](#requirement\_routeros) | ~> 1.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_routeros"></a> [routeros](#provider\_routeros) | ~> 1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [routeros_interface_bridge_port.untagged_interfaces](https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_port) | resource |
| [routeros_interface_bridge_vlan.vlan_interfaces](https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_bridge_vlan) | resource |
| [routeros_interface_vlan.this](https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/interface_vlan) | resource |
| [routeros_ip_address.this](https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_address) | resource |
| [routeros_ip_dhcp_server.this](https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server) | resource |
| [routeros_ip_dhcp_server_network.this](https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_dhcp_server_network) | resource |
| [routeros_ip_pool.this](https://registry.terraform.io/providers/terraform-routeros/routeros/latest/docs/resources/ip_pool) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bridge"></a> [bridge](#input\_bridge) | Bridge interface to attach this VLAN to. Ensure that the bridge has vlan filtering enabled. | `string` | n/a | yes |
| <a name="input_cidr"></a> [cidr](#input\_cidr) | Assigns an address to the created VLAN interface. Set to null (default) to<br>disable creating an address on the router / switch. When enabling a DHCP<br>server, this address is used as a  gateway and must not be null. Address<br>must be given in CIDR notation.<br><br>Example: `"172.16.10.1/24"` | `string` | `null` | no |
| <a name="input_dhcp_dns_servers"></a> [dhcp\_dns\_servers](#input\_dhcp\_dns\_servers) | List of DNS servers to advertise in DHCP offers. Has no effect if `enable_dhcp` is false.<br><br>Example: `["8.8.8.8", "1.1.1.1"]` | `list(string)` | `[]` | no |
| <a name="input_dhcp_enable"></a> [dhcp\_enable](#input\_dhcp\_enable) | Whether to enable creation of a DHCP server for this VLAN. Requires `gateway` to be set. | `bool` | `false` | no |
| <a name="input_dhcp_lease_time"></a> [dhcp\_lease\_time](#input\_dhcp\_lease\_time) | Lease time of DHCP offers. Has no effect if `enable_dhcp` is false.<br><br>Example: `"60m"` | `string` | `"30m"` | no |
| <a name="input_dhcp_ranges"></a> [dhcp\_ranges](#input\_dhcp\_ranges) | List of address ranges to allocate for DHCP. Has no effect if `enable_dhcp` is false.<br>(e.g. )<br><br>   Example: `["192.168.88.100-192.168.88.200", "192.168.88.50-192.168.88.60"]` | `list(string)` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Identifier for this VLAN. | `string` | n/a | yes |
| <a name="input_tagged_interfaces"></a> [tagged\_interfaces](#input\_tagged\_interfaces) | List of tagged interfaces / ports to assign to this VLAN. Any untagged<br>frames passing through these interfaces which are dropped. Tagged<br>interfaces must be *manually* added to the bridge by the user.<br><br>Example: `["ether1", "ether2"]` | `list(string)` | `[]` | no |
| <a name="input_untagged_interfaces"></a> [untagged\_interfaces](#input\_untagged\_interfaces) | List of untagged interfaces / ports to assign to this VLAN. Any traffic<br>passing through these interfaces is implicitly assigned the associated VLAN<br>ID, even if frames are untagged. Untagged interfaces are automatically<br>added to the bridge and assigned the respective VLAN ID.<br><br>Example: `["ether1", "ether2"]` | `list(string)` | `[]` | no |
| <a name="input_vlan_id"></a> [vlan\_id](#input\_vlan\_id) | VLAN ID to assign to this subnet. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_gateway"></a> [gateway](#output\_gateway) | The gateway address of the VLAN. Set to `null` if no CIDR was given. |
| <a name="output_interface"></a> [interface](#output\_interface) | The VLAN interface, if created. |
| <a name="output_name"></a> [name](#output\_name) | The name of the created VLAN. |
| <a name="output_network"></a> [network](#output\_network) | The VLAN network, in CIDR form. This may be used to reference the subnet, for instance in firewall rules. |
