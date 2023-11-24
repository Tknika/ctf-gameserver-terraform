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

  disk {
      datastore_id = var.pve-vm-ds
  }

  network_interface {
    name    = "eth0"
    bridge  = "vmbr0"
#    vlan_id = "99"
  }

  operating_system {
    template_file_id = proxmox_virtual_environment_file.debian11_container_template.id
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

resource "null_resource" "gameserver-config" {
  depends_on = [
    proxmox_virtual_environment_container.gameserver
  ]

  connection {
    type        = "ssh"
    host        = var.gameserver-instance-username
    user        = var.gameserver-priv-ip
    port        = "22"
    private_key = tls_private_key.gameserver-tls-key.private_key_openssh
    agent       = false
  }

  provisioner "file" {
    source      = "scripts/gameserver-config.sh"
    destination = "${var.gameserver-instance-user-path}/gameserver-config.sh"
  }

  provisioner "file" {
    source      = "files/gameserver/ctf-gameserver_1.0_all.deb"
    destination = "${var.gameserver-instance-user-path}/ctf-gameserver_1.0_all.deb"
  }

  provisioner "file" {
    source      = "files/gameserver/playbook.yml"
    destination = "${var.gameserver-instance-user-path}/playbook.yml"
  }

  provisioner "file" {
    source      = "files/gameserver/uwsgi.ini"
    destination = "${var.gameserver-instance-user-path}/uwsgi.ini"
  }

  provisioner "file" {
    source      = "files/gameserver/nginx.conf"
    destination = "${var.gameserver-instance-user-path}/nginx.conf"
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "chmod +x /home/${var.gameserver-instance-username}/gameserver-config.sh",
  #     "sudo /home/${var.gameserver-instance-username}/gameserver-config.sh"
  #   ]
  # }
}
