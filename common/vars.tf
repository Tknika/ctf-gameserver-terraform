variable "instance_root_block_device_volume_size" {
  description = "The size of the root block device volume of the EC2 instance in GiB"
  default     = 8
}

variable "team-count"{
    type = number
    description = "how many teams will play"
    default = 2
}

variable "aws-gameserver-openvpn-instance-private-key" {
    default = "output/master-openvpn-instance-sshkey"
}

variable "aws-opnevpn-instance-private-key" {
    default = "output/openvpn-instance-sshkey"
}

#Services variables

variable "service-instance-username" {
    type        = list
    description = "service instance username"
    default     = [
        "ubuntu"
    ]
}

#Openvpn variables

variable "openvpn-instance-username" {
    description = "openvpn instace username"
    default = "ec2-user"
}

variable "ovpn-users" {
    type        = list(string)
    description = "vpn access users"
    default     = [
        "team"
    ]
}

variable "ovpn-config-directory" {
    default = "output/team"  #usually with count.index ex: output/team1
}

variable "openvpn-install-script-location" {
    default = "https://raw.githubusercontent.com/dumrauf/openvpn-install/master/openvpn-install.sh"
}

#VPC CIDRs

variable "services-vpc-cidr" {
    #first two block
    default = "10.0.0.0/16"
}

variable "gamezone-vpc-cidr" {
    #first two block
    default = "10.255.0.0/16"
}

#Subnet CIDRs

variable "team-services-subnet-cidr-init" {
    #first two block
    default = "10.0"
}

variable "services-egress-nat-subnet-cidr" {
    #first two block
    default = "10.0.255.0/24"
}

variable "openvpn-team-subnet-cidr" {
    default = "10.255.0.0/17"
}

variable "gameserver-subnet-cidr" {
    default = "10.255.254.0/24"
}

variable "gamezone-nat-subnet-cidr" {
    default = "10.255.255.0/24"
}

variable "internet-cidr" {
    default = "0.0.0.0/0"
}

#Instances private IPs

variable "gameserver-openvpn-priv-ip" {
    default = "10.255.254.100"
}

#Gameserver variables
variable "gameserver-instance-username" {}
variable "gameserver-instance-user-path" {}
variable "gameserver-priv-ip-CIDR" {}
variable "gameserver-priv-ip" {}
variable "gameserver-priv-gw" {}

##Gameserver-sub variables
variable "gameserver-sub-instance-username" {}
variable "gameserver-sub-instance-user-path" {}
variable "gameserver-sub-priv-ip-CIDR" {}
variable "gameserver-sub-priv-ip" {}
variable "gameserver-sub-priv-gw" {}

#Service1 variables
variable "service1-instance-username" {}
variable "service1-instance-user-path" {}
# variable "service1-priv-ip-CIDR" {}
# variable "service1-priv-ip" {}
# variable "service1-priv-gw" {}

#Team Submission variables
variable "team-sub-instance-username" {}
variable "team-sub-instance-user-path" {}
# variable "team-sub-priv-ip-CIDR" {}
variable "team-sub-priv-ip-pattern" {}
# variable "team-sub-priv-gw" {}


#Output
variable "output-path" {}
