resource "proxmox_virtual_environment_file" "ubuntu_container_template" {
  content_type = "vztmpl"
  datastore_id = var.pve-templ-ds
  node_name    = var.pve-node

  source_file {
    path      = "http://51.91.38.34/images/system/ubuntu-20.04-standard_20.04-1_amd64.tar.gz"
    file_name = "ubuntu-20.04-standard.tar.gz"
  }
}

resource "proxmox_virtual_environment_file" "debian11_container_template" {
  content_type = "vztmpl"
  datastore_id = var.pve-templ-ds
  node_name    = var.pve-node

  source_file {
    path      = "http://51.91.38.34/images/system/debian-11-standard_11.7-1_amd64.tar.zst"
    file_name = "debian-11-standard.tar.zst"
  }
}