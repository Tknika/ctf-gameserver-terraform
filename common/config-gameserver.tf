resource "null_resource" "upload-checkers" {

for_each = fileset("files/gameserver/checkers", "*")

  connection {
    type        = "ssh"
    host        = var.gameserver-priv-ip
    user        = var.gameserver-instance-username
    port        = "22"
    private_key = file("${var.output-path}/master-sshkey")
    agent       = false
  }

  provisioner "file" {
    source      = "files/gameserver/checkers/${each.value}"
    destination = "${var.gameserver-instance-user-path}/${each.value}"
  }

}


resource "null_resource" "gameserver-config" {
  depends_on = [ null_resource.upload-checkers ]

  connection {
    type        = "ssh"
    host        = var.gameserver-priv-ip
    user        = var.gameserver-instance-username
    port        = "22"
    private_key = file("${var.output-path}/master-sshkey")
    agent       = false
  }

  provisioner "file" {
    source      = "scripts/gameserver-config.sh"
    destination = "${var.gameserver-instance-user-path}/gameserver-config.sh"
  }

  provisioner "file" {
    source      = "files/gameserver/ctf-gameserver_1.0_all.deb"
    destination = "/tmp/ctf-gameserver_1.0_all.deb"
  }

  provisioner "file" {
    source      = "files/gameserver/playbook.yml"
    destination = "${var.gameserver-instance-user-path}/playbook.yml"
  }

  provisioner "file" {
    source      = "files/gameserver/prod_settings.py.j2"
    destination = "${var.gameserver-instance-user-path}/prod_settings.py.j2"
  }

  provisioner "file" {
    source      = "files/gameserver/uwsgi.ini"
    destination = "${var.gameserver-instance-user-path}/uwsgi.ini"
  }

  provisioner "file" {
    source      = "files/gameserver/nginx.conf"
    destination = "${var.gameserver-instance-user-path}/nginx.conf"
  }

  provisioner "remote-exec" {
     inline = [
       "apt install sudo -y",
       "chmod +x ${var.gameserver-instance-user-path}/gameserver-config.sh",
       "sudo ${var.gameserver-instance-user-path}/gameserver-config.sh"
     ]
   }
}
