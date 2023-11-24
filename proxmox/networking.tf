#######
#One VLAN per Team

resource "proxmox_virtual_environment_network_linux_vlan" "vlanteam" {
   depends_on = [ proxmox_virtual_environment_network_linux_bridge.vmbrteam ]

  node_name = var.pve-node
  count   = var.team-count
  name    = "vmbr100.${100+count.index}"
  comment = "ATC-DEF VLAN ${100+count.index}"
}

#######
#One bridge

resource "proxmox_virtual_environment_network_linux_bridge" "vmbrteam" {

  node_name = var.pve-node
  name    = "vmbr100"
  comment = "ATC-DEF Bridge 100"

  # address = "99.99.99.99/16"

  # ports = [
  #   "ens18.99"
  # ]
}

