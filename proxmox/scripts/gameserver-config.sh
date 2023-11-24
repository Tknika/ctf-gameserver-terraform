#!/bin/bash

sudo apt update && sudo apt upgrade -y
sudo apt install git ansible -y

git clone https://github.com/fausecteam/ctf-gameserver-ansible.git

mv playbook.yml ctf-gameserver-ansible

cd ctf-gameserver-ansible

sudo ansible-playbook playbook.yml

cd ..

#uwsgi
#sudo apt install python3-dev python3-pip gcc # python3-venv -y #errepasatu ea venv beahr den
sudo apt install uwsgi uwsgi-plugin-python3 -y
sudo uwsgi uwsgi.ini &

# python3 -m venv venv
# source venv/bin/activate
# pip install uwsgi
# deactivate

#nginx
sudo apt install nginx -y
sudo mv nginx.conf /etc/nginx/sites-available/ctf_gameserver.conf
sudo rm /etc/nginx/sites-enabled/default
sudo ln -s /etc/nginx/sites-available/ctf_gameserver.conf /etc/nginx/sites-enabled/
sudo systemctl restart nginx

#corrections
#/etc/ctf-gameserver/web/prod_settings.py fitxategian ALLOWED_HOSTS = ['*']