#!/bin/sh

cd /usr/local/deployer/resources

# install resource dependencies
terraform init

# apply changes to infrastructure
terraform apply -auto-approve
