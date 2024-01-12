resource "null_resource" "team-config-sub" {

  count = var.team-count

  # Establishes an SSH connection to the game server instance.
  # This connection block specifies the SSH connection details such as the host IP, username, port, private key, and agent usage.
  connection {
    type        = "ssh"
    host        = format(var.team-sub-priv-ip-pattern,count.index)
    user        = var.team-sub-instance-username
    port        = "22"
    private_key = file("${var.output-path}/team${count.index}/team${count.index}-sshkey")
    agent       = false
  }

  # Copy service file
  provisioner "file" {
    source      = "files/submission.service"
    destination = "/etc/systemd/system/submission.service"
  }

  # Copy service executable
  provisioner "file" {
    source      = "files/ctf-team-submission"
    destination = "/usr/bin/ctf-team-submission"
  }

  # Create directory for submission.env
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /etc/ctf-team-submission",
    ]
  }

  # Copy submission.env
  provisioner "file" {
    source      = "files/submission.env"
    destination = "/etc/ctf-team-submission/submission.env"
  }

  # Create directory for submission.py and create __init__.py
  provisioner "remote-exec" {
    inline = [
      "mkdir -p /usr/lib/python3/dist-packages/ctfteamsubmission",
      "echo 'from ctfteamsubmission.submission import main' > /usr/lib/python3/dist-packages/ctfteamsubmission/__init__.py"
    ]
  }

  # Copy submission.py
  provisioner "file" {
    source      = "files/submission.py"
    destination = "  /usr/lib/python3/dist-packages/ctfteamsubmission/submission.py"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /usr/bin/ctf-team-submission",
      "systemctl daemon-reload",
      "systemctl enable submission.service",
      "systemctl start submission.service",
    ]
  }
}
