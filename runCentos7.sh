#!/bin/bash

echo "Attempting to run to container: $1 with asterisk volume $2 and output volume $3";

docker run \
--name $1 -it -d \
--mount source=$2,target=/usr/src/asterisk \
--mount source=$3,target=/usr/src/ast-output \
testsuite/centos7 bash