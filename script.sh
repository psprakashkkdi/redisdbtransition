#!/bin/bash
#set connection  accordingly
source_host=localhost # replace localhost if its not from your local machine.Provide the ip in double quotes eg:"192.168.2.***"
source_port=6379 #give the port number if you have changed default port
source_db=1 #give the required database number of the source
target_host=localhost # replace localhost if its not from your local machine.Provide the ip in double quotes eg:"192.168.2.***"
target_port=6379 #give the port number if you have changed default port
target_db=2 #give the required database number of the target

#copy all keys without preserving ttl!
redis-cli -h $source_host -p $source_port -n $source_db keys \* | while read key;
do
    echo "Processing $key"
    redis-cli --raw -h $source_host -p $source_port -n $source_db DUMP "$key" | head -c -1 | redis-cli -x -h $target_host -p $target_port -n $target_db RESTORE "$key" 0
done
