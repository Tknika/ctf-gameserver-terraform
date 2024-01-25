resource "proxmox_virtual_environment_container" "team-submission" {
  description = "Managed by Terraform"

  node_name = var.pve-node

  count = var.team-count

  vm_id     = 1500 + count.index

  initialization {
    hostname = "team${count.index}-submission"

    ip_config {
      ipv4 {
        address = "10.0.${count.index}.1/24"
        gateway = "10.0.${count.index}.254"
      }
    }

    user_account {
      keys = [
        trimspace(tls_private_key.team-tls-key[count.index].public_key_openssh)
      ]
      password = random_password.teamsubmission_password.result
    }
  }

  disk {
      datastore_id = var.pve-vm-ds
      size         = 40
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr999"
    vlan_id = "${100+count.index}"
  }

  operating_system {
    template_file_id = "local2:vztmpl/debian-12-standard_12.2-1_amd64.tar.zst" #proxmox_virtual_environment_file.debian11_container_template.id
    type             = "debian"
  }

}

resource "random_password" "teamsubmission_password" {
  length           = 16
  override_special = "_%@"
  special          = true
}

output "teamsubmission_password" {
  value = random_password.teamsubmission_password.result
  sensitive = true
}