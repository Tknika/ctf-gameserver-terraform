#!/bin/bash

apt install sudo
sudo apt update && sudo apt upgrade -y
sudo apt install git ansible -y

git clone https://github.com/fausecteam/ctf-gameserver-ansible.git

mv playbook-sub.yml ctf-gameserver-ansible/

#Install Gameserver with ansible
cd ctf-gameserver-ansible
sudo ansible-playbook playbook-sub.yml
cd ..