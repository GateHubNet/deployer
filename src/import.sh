#!/bin/sh

test -z "$IMPORT_TF" && echo "IMPORT_TF env variable is required" && exit 1
test -z "$IMPORT_CMD" && echo "IMPORT_CMD env variable is required" && exit 1

mkdir -p /usr/local/deployer/import-resources

cd /usr/local/deployer/import-resources

echo "$IMPORT_TF" > main.tf

# install resource dependencies
terraform init

# wait on global lock
while true
do
    curl -s $LOCK_ENDPOINT | grep -q '"value":"lock"'
    if [ $? -eq 0 ]
    then
        echo "Locked ..."
        sleep 1
    else
        break
    fi
done

# set global lock
curl -s -XPUT $LOCK_ENDPOINT -d value="lock"

# import resource to state
terraform import $IMPORT_CMD
EXIT_STATUS=$?

# remove global lock
curl -s -XDELETE $LOCK_ENDPOINT

if [ $EXIT_STATUS -eq 0 ]
then
    echo "State applied!"
else
    echo "Error: $EXIT_STATUS"
fi
