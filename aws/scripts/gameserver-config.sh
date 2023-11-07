#!/bin/bash

#avoid apt popups
sudo sed -i 's/#$nrconf{restart} = '"'"'i'"'"';/$nrconf{restart} = '"'"'a'"'"';/g' /etc/needrestart/needrestart.conf
sudo sed -i "s/#\$nrconf{kernelhints} = -1;/\$nrconf{kernelhints} = -1;/g" /etc/needrestart/needrestart.conf

#upgrade and install basic software
sudo apt update && sudo apt upgrade -y
sudo apt install python3-pip make unzip -y

#git clone and run ./setup install
git clone https://github.com/xzabala/ctf-gameserver.git

#Create and enter to virtual env (optional)
# python3 -m venv venv
# source venv/bin/activate

#run setup.py install

sudo ctg-gameserver/setup.py install

#NGINX: install and start
sudo apt install nginx -y
sudo systemctl start nginx

#uWSGI: install
pip install uwsgi

#Move src to /etc
sudo mv ctf-gameserver/src/ctf_gameserver /etc

#Install uwsgi
sudo apt install uwsgi-core -y
sudo apt install uwsgi-plugin-python3 -y