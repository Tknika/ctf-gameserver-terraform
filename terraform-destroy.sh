#!/bin/bash

terraform -chdir=$1 destroy -auto-approve -var-file=../$1.tfvars
rm -r $1/output 2>&1
