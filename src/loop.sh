#!/bin/sh

APPLY_COMMAND="./src/apply.sh"
ERROR_SLEEP_SECONDS="${ERROR_SLEEP_SECONDS:-10}"

mkdir -p /usr/local/deployer/resources

while true
do
    RESOURCES=`find /usr/local/deployer/inputs -type f ( -iname '*.tf' -or -iname '*.tf.json' )`
    NEW_OUTPUT="`echo $RESOURCES | xargs ls -le`"

    if [ "$NEW_OUTPUT" != "$OLD_OUTPUT" ]
    then
        # atime of resource files changed

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

        # separation of resource files and data files
        # remove previous symlinks
        find /usr/local/deployer/resources -type l -maxdepth 1 -delete
        # create new links
        index=0
        for resource in $RESOURCES
        do
            filename="$index-`basename $resource`"
            ln -svf "$resource" "/usr/local/deployer/resources/$filename"
            index=$(($index+1))
        done

        # set global lock
        curl -s -XPUT $LOCK_ENDPOINT -d value="lock"

        # apply terraform resources
        $APPLY_COMMAND
        APPLY_EXIT_STATUS=$?

        # remove global lock
        curl -s -XDELETE $LOCK_ENDPOINT

        if [ $APPLY_EXIT_STATUS -eq 0 ]
        then
            echo "Resources applied!"
        else
            echo "Error: $APPLY_EXIT_STATUS, sleeping $ERROR_SLEEP_SECONDS ..."
            sleep $ERROR_SLEEP_SECONDS
            if [[ $EXIT_ON_ERROR ]]
            then
                exit $APPLY_EXIT_STATUS
            else
                NEW_OUTPUT=""
            fi
        fi

        OLD_OUTPUT="$NEW_OUTPUT"
    fi

    sleep 1
done
