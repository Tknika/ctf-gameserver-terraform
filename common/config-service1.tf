resource "null_resource" "service1-config" {

  count = var.team-count


  connection {
    type        = "ssh"
    host        = "${var.team-services-subnet-cidr-init}.${count.index}.101"
    user        = var.service1-instance-username
    port        = "22"
    private_key = file("${var.output-path}/team${count.index}/team${count.index}-sshkey")
    agent       = false
  }

  provisioner "file" {
    source      = "scripts/service1-config.sh"
    destination = "${var.service1-instance-user-path}/service1-config.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "apt install sudo -y",
      "chmod +x ${var.service1-instance-user-path}/service1-config.sh",
      "sudo ${var.service1-instance-user-path}/service1-config.sh"
    ]
  }
}
