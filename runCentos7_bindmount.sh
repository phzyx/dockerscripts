#!/bin/bash

echo "Attempting to run to container: $1 on fixed asterisk-docker bind";

docker run \
--name $1 -it -d \
--mount type=bind,source=/usr/src/asterisk-docker,target=/usr/src/asterisk \
--mount type=bind,source=/usr/src/docker-results,target=/usr/src/ast-output \
testsuite/centos7 bash