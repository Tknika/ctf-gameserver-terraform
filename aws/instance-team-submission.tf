resource "aws_instance" "team-submision" {
  ami           = "ami-058bd2d568351da34"
  instance_type = var.aws-instance-type

  count = var.team-count

  key_name = aws_key_pair.team-ssh-key[count.index].key_name
  
  network_interface {
    network_interface_id = aws_network_interface.team-sub-priv-interface[count.index].id
    device_index         = 0
  }

  tags = {
   Name = "Team${count.index}-submission"
 }
}