#!/bin/sh

APPLY_COMMAND="./src/apply.sh"
ERROR_SLEEP_SECONDS="${ERROR_SLEEP_SECONDS:-10}"

mkdir -p /usr/local/deployer/resources

trap "exit" SIGTERM
while true
do
    RESOURCES=`find /usr/local/deployer/inputs -type f ( -iname '*.tf' -or -iname '*.tf.json' )`
    NEW_OUTPUT="`echo $RESOURCES | xargs ls -l`"

    if [ "$NEW_OUTPUT" != "$OLD_OUTPUT" ]
    then
        # atime of resource files changed

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

        # apply terraform resources
        $APPLY_COMMAND
        APPLY_EXIT_STATUS=$?

        if [ $APPLY_EXIT_STATUS -eq 0 ]
        then
            echo "Resources applied!"
            if [[ $EXIT_ON_SUCCESS ]]
            then
                exit $APPLY_EXIT_STATUS
            fi
        else
            echo "Error: $APPLY_EXIT_STATUS"
            if [[ $EXIT_ON_ERROR ]]
            then
                exit $APPLY_EXIT_STATUS
            else
                NEW_OUTPUT=""
            fi
            echo "sleeping $ERROR_SLEEP_SECONDS ..."
            sleep $ERROR_SLEEP_SECONDS
        fi

        OLD_OUTPUT="$NEW_OUTPUT"
    fi

    sleep 1
done
