resource "null_resource" "gameserver-config-sub" {

  # Establishes an SSH connection to the game server instance.
  # This connection block specifies the SSH connection details such as the host IP, username, port, private key, and agent usage.
  connection {
    type        = "ssh"
    host        = var.gameserver-sub-priv-ip
    user        = var.gameserver-instance-username
    port        = "22"
    private_key = file("${var.output-path}/master-sshkey")
    agent       = false
  }

  provisioner "file" {
    source      = "scripts/gameserver-sub-config.sh"
    destination = "${var.gameserver-instance-user-path}/gameserver-sub-config.sh"
  }

  provisioner "file" {
    source      = "files/gameserver/ctf-gameserver_1.0_all.deb"
    destination = "/tmp/ctf-gameserver_1.0_all.deb"
  }

  provisioner "file" {
    source      = "files/gameserver/playbook-sub.yml"
    destination = "${var.gameserver-instance-user-path}/playbook-sub.yml"
  }

  provisioner "remote-exec" {
     inline = [
       "apt install sudo -y",
       "chmod +x ${var.gameserver-instance-user-path}/gameserver-sub-config.sh",
       "sudo ${var.gameserver-instance-user-path}/gameserver-sub-config.sh"
     ]
   }
}
