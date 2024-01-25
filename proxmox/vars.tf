#PVE (Proxmox Virtual Enviroment) variables

variable "pve-endpoint" {}
variable "pve-username" {}
variable "pve-password" {}
variable "pve-insecure" {}
variable "pve-tmppath" {}
variable "pve-node" {}
variable "pve-templ-ds" {}  #templates datastore
variable "pve-vm-ds" {}

#Game variables
variable "team-count" { default = 2}

#Gameserver variables
variable "gameserver-instance-username" {}
variable "gameserver-instance-user-path" {}
variable "gameserver-priv-ip-CIDR" {}
variable "gameserver-priv-ip" {}
variable "gameserver-priv-gw" {}

##Gameserver-sub variables
variable "gameserver-sub-instance-username" {}
variable "gameserver-sub-instance-user-path" {}
variable "gameserver-sub-priv-ip-CIDR" {}
variable "gameserver-sub-priv-ip" {}
variable "gameserver-sub-priv-gw" {}

#OpenVPN variables
variable "openvpn-instance-username" {}
variable "openvpn-instance-user-path" {}
variable "openvpn-port" {}
variable "openvpn-install-script-location" {} 
variable "ovpn-users" {}

#Service1 variables
variable "service-instance-username" {}
variable "service-instance-user-path" {}
variable "service-priv-ip-CIDR" {}
variable "service-priv-ip" {}
variable "service-priv-gw" {}
