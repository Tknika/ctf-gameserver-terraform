resource "proxmox_virtual_environment_container" "service1" {
  description = "Managed by Terraform"

  node_name = var.pve-node

  count = var.team-count

  vm_id     = 1000 + count.index

  initialization {
    hostname = "team${count.index}-service1"

    ip_config {
      ipv4 {
        address = "192.168.${count.index}.1/24"
        gateway = "192.168.${count.index}.254"
      }
    }

    user_account {
      keys = [
        trimspace(tls_private_key.team-tls-key[count.index].public_key_openssh)
      ]
    }
  }

  disk {
      datastore_id = var.pve-vm-ds
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr100"
#    vlan_id = "${100+count.index}"
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_file.ubuntu_container_template.id
    type             = "ubuntu"
  }

#  mount_point {
#    volume = "/mnt/bindmounts/shared"
#    path   = "/shared"
#  }

}
