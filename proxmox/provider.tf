terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
      version = "0.38.1"
    }
  }
}

provider "proxmox" {
  endpoint = var.pve-endpoint
  username = var.pve-username
  password = var.pve-password
  insecure = var.pve-insecure
  tmp_dir  = var.pve-tmppath
}