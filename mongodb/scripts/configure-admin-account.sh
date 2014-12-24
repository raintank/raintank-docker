LOG_FILE=/var/log/mongodb.log
SCRIPT_FILE=/scripts/create-admin-account.js
ADMIN_CREATED_FLAG=/config/admin-created.flag

# Wait until mongo logs that it's ready (or timeout after 60s)
echo "Waiting for mongo to initialize."
COUNTER=0
grep -q 'waiting for connections on port' $LOG_FILE
while [[ $? -ne 0 && $COUNTER -lt 200 ]] ; do
    sleep 1
    let COUNTER+=1
    grep -q 'waiting for connections on port' $LOG_FILE
done

# Now we know mongo is ready and can continue with other commands

if [ ! -f $ADMIN_CREATED_FLAG ]; then
    echo "Admin user does not exists."

    mongo < $SCRIPT_FILE

    touch $ADMIN_CREATED_FLAG
    
    echo MongoDB admin account configured.
    echo creating user account
    mongo -u admin -p adminPass --authenticationDatabase admin < /scripts/create-user-account.js
    echo Created user account
fi
