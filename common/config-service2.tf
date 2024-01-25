locals {
  all_files  = tolist(setproduct(range(var.team-count), fileset("files/service2","**")))
}

resource "null_resource" "create_service2_folder" {
  count = var.team-count

  connection {
    type        = "ssh"
    host        = "${var.team-services-subnet-cidr-init}.${count.index}.101"
    user        = var.service-instance-username
    port        = "22"
    private_key = file("${var.output-path}/team${count.index}/team${count.index}-sshkey")
    agent       = false
  }
  provisioner "remote-exec" {
    inline = [
      "mkdir -p ${var.service-instance-user-path}/service2",
      "mkdir -p ${var.service-instance-user-path}/service2/app"
    ]
  }
}

resource "null_resource" "process_files" {
  depends_on = [ null_resource.create_service2_folder ]

  count = length(local.all_files)

  connection {
    type        = "ssh"
    host        = "${var.team-services-subnet-cidr-init}.${(local.all_files[count.index])[0]}.101"
    user        = var.service-instance-username
    port        = "22"
    private_key = file("${var.output-path}/team${(local.all_files[count.index])[0]}/team${(local.all_files[count.index])[0]}-sshkey")
    agent       = false
  }

  provisioner "file" {
    source      = "files/service2/${(local.all_files[count.index])[1]}"
    destination = "${var.service-instance-user-path}/service2/${(local.all_files[count.index])[1]}"
  }

}

# resource "null_resource" "service2-config" {

#   count = var.team-count


#   connection {
#     type        = "ssh"
#     host        = "${var.team-services-subnet-cidr-init}.${count.index}.101"
#     user        = var.service-instance-username
#     port        = "22"
#     private_key = file("${var.output-path}/team${count.index}/team${count.index}-sshkey")
#     agent       = false
#   }

#   provisioner "file" {
#     source      = "scripts/service2-config.sh"
#     destination = "${var.service-instance-user-path}/service2-config.sh"
#   }

#   provisioner "remote-exec" {
#     inline = [
#       "apt install sudo -y",
#       "chmod +x ${var.service-instance-user-path}/service2-config.sh",
#       "sudo ${var.service-instance-user-path}/service2-config.sh"
#     ]
#   }
# }
