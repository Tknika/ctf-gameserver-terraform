resource "proxmox_virtual_environment_container" "gameserver" {
  description = "Managed by Terraform"

  node_name = var.pve-node

  vm_id     = 1999

  initialization {
    hostname = "gameserver"

    ip_config {
      ipv4 {
        address = var.gameserver-priv-ip-CIDR
        gateway = var.gameserver-priv-gw
      }
    }

    user_account {
      keys = [
        trimspace(tls_private_key.gameserver-tls-key.public_key_openssh)
      ]
      password = random_password.gameserver_password.result
    }
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
  }

  disk {
      datastore_id = var.pve-vm-ds
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr999"
    vlan_id = "254"
  }

  features {
    nesting = true
  }

  operating_system {
    template_file_id = "local2:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst" #proxmox_virtual_environment_file.debian11_container_template.id
    type             = "debian"
  }

#  mount_point {
#    volume = "/mnt/bindmounts/shared"
#    path   = "/shared"
#  }

}

resource "random_password" "gameserver_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

output "gameserver-password" {
  value = random_password.gameserver_password.result
  sensitive = true
}