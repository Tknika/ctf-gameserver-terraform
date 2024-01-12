#!/bin/bash

apt update
apt install git docker-compose -y
git clone https://github.com/fausecteam/faustctf-2021-pirate-birthday-planner
cd faustctf-2021-pirate-birthday-planner/src/
docker-compose up -d