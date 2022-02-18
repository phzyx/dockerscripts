#!/bin/bash

echo "Attempting to attach to running container: $1 and install pre-reqs";

# install prereq, has to be done each time as this is part of asterisk source
echo "running asterisk rereq install"
docker exec -it -w /usr/src/asterisk/asterisk $1 contrib/scripts/install_prereq install