#!/bin/bash

if [ $# -eq 1 ]
then
    docker exec -it -w /usr/src/asterisk/testsuite $1 ./runtests.py
elif [ $2 = "all" ]
then
    docker exec -it -w /usr/src/asterisk/testsuite $1 ./runtests.py
elif [ $2 = "list" ]
then
    docker exec -it -w /usr/src/asterisk/testsuite $1 ./runtests.py -l
else
    echo "Attempting to attach to container: $1 to run test(s) $2";
    # run passed test(s)
    docker exec -it -w /usr/src/asterisk/testsuite $1 ./runtests.py -t $2
    #| tee -a /usr/src/ast-output/$2-results.txt
fi