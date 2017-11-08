#!/bin/sh

test -z "$IMPORT_TF" && echo "IMPORT_TF env variable is required" && exit 1
test -z "$IMPORT_CMD" && echo "IMPORT_CMD env variable is required" && exit 1

mkdir -p /usr/local/deployer/import-resources

cd /usr/local/deployer/import-resources

echo "$IMPORT_TF" > main.tf

# install resource dependencies
terraform init

# import resource to state
terraform import $IMPORT_CMD
EXIT_STATUS=$?

if [ $EXIT_STATUS -eq 0 ]
then
    echo "State applied!"
else
    echo "Error: $EXIT_STATUS"
fi
