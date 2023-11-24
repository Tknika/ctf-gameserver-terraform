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
variable "team-count" {}

#Gameserver variables
variable "gameserver-instance-username" {}
variable "gameserver-instance-user-path" {}
variable "gameserver-priv-ip-CIDR" {}
variable "gameserver-priv-ip" {}
variable "gameserver-priv-gw" {}

