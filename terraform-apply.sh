#!/bin/bash

terraform -chdir=$1 apply -auto-approve -var team-count=$2 -var-file=../$1.tfvars -compact-warnings
ssh-keygen -f "/home/xza/.ssh/known_hosts" -R "10.255.254.200" 
ssh-keygen -f "/home/xza/.ssh/known_hosts" -R "10.255.254.210"