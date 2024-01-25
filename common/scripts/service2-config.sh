#!/bin/bash

apt update
apt install git docker-compose -y
cd service2
docker-compose up -d
cd ..