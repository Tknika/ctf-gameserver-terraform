#Output folders creation

resource "null_resource" "output-main-folder" {

 provisioner "local-exec" {
   command = "mkdir output 2>&1"
 }
}

resource "null_resource" "output-team-folders" {
  depends_on = [null_resource.output-main-folder]

  count = var.team-count

  provisioner "local-exec" {
    command = "mkdir output/team${count.index}"
  }
}

#Keys

resource "tls_private_key" "gameserver-openvpn-instance-tls-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "gameserver-tls-key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "team-openvpn-instance-tls-key" {
  count     = var.team-count

  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "tls_private_key" "team-tls-key" {
  count = var.team-count

  algorithm = "RSA"
  rsa_bits  = 4096
}

#Save private key to file

resource "local_file" "master-openvpn-instance-private-key-file" {
    depends_on = [null_resource.output-team-folders]

    file_permission = "600"
    content  = tls_private_key.gameserver-openvpn-instance-tls-key.private_key_openssh
    filename = "output/master-openvpn-instance-sshkey"
}

resource "local_file" "master-private-key-file" {
    depends_on = [null_resource.output-team-folders]

    file_permission = "600"
    content  = tls_private_key.gameserver-tls-key.private_key_openssh
    filename = "output/master-sshkey"
}

resource "local_file" "team-openvpn-instance-private-key-file" {
    depends_on = [null_resource.output-team-folders]

    count    = var.team-count

    file_permission = "600"
    content  = tls_private_key.team-openvpn-instance-tls-key[count.index].private_key_openssh
    filename = "output/team${var.team-count}/openvpn-instance-sshkey"
}

resource "local_file" "team-private-key-file" {
    depends_on = [null_resource.output-team-folders]

    count = var.team-count
    
    file_permission = "600"
    content  = tls_private_key.team-tls-key[count.index].private_key_openssh
    filename = "output/team${count.index}/team${count.index}-sshkey"
}
