#!/bin/sh

#!/bin/bash

counter=0

until [ $counter -gt 2 ]
do
    echo Waiting: $counter
    ((counter++))
    docker exec -it lab3_cassandra_1 /bin/sh
    sleep 1
done
