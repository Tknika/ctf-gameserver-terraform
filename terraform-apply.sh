#!/bin/bash

terraform -chdir=$1 apply -auto-approve -var team_count=$2
ssh-keygen -f "/home/xza/.ssh/known_hosts" -R "10.255.254.200"