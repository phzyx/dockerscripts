#!/bin/bash

echo "Attempting to attach to container: $1 and build asterisk $2";

# assume asterisk directories already exist within volume and we want to simple checkout the passed branch
echo "Checking out asterisk..."
docker exec -it -w /usr/src/asterisk/asterisk $1 git checkout $2
docker exec -it -w /usr/src/asterisk/asterisk $1 git pull
echo "Checking out testsuite..."
docker exec -it -w /usr/src/asterisk/testsuite $1 git checkout $2
docker exec -it -w /usr/src/asterisk/testsuite $1 git pull

# install prereq, has to be done each time as this is part of asterisk source
echo "running asterisk rereq install"
docker exec -it -w /usr/src/asterisk/asterisk $1 contrib/scripts/install_prereq install

#build asterisk
echo "building asterisk $2"
docker exec -it -w /usr/src/asterisk/asterisk $1 make distclean
docker exec -it -w /usr/src/asterisk/asterisk $1 ./configure --enable-dev-mode --disable-binary-modules --with-jansson-bundled --with-pjproject-bundled
docker exec -it -w /usr/src/asterisk/asterisk $1 make menuselect.makeopts
docker exec -it -w /usr/src/asterisk/asterisk $1 menuselect/menuselect --enable DONT_OPTIMIZE menuselect.makeopts
docker exec -it -w /usr/src/asterisk/asterisk $1 menuselect/menuselect --enable TEST_FRAMEWORK menuselect.makeopts
docker exec -it -w /usr/src/asterisk/asterisk $1 menuselect/menuselect --enable MALLOC_DEBUG menuselect.makeopts
docker exec -it -w /usr/src/asterisk/asterisk $1 menuselect/menuselect --enable DO_CRASH menuselect.makeopts
docker exec -it -w /usr/src/asterisk/asterisk $1 menuselect/menuselect --disable COMPILE_DOUBLE menuselect.makeopts
docker exec -it -w /usr/src/asterisk/asterisk $1 make

#install asterisk
echo "installing asterisk $2"
docker exec -it -w /usr/src/asterisk/asterisk $1 make install
docker exec -it -w /usr/src/asterisk/asterisk $1 make samples

#init and finish up testsuite install
echo "checking testsuite"
docker exec -it -w /usr/src/asterisk/testsuite/asttest $1 make
docker exec -it -w /usr/src/asterisk/testsuite/asttest $1 make install
docker exec -it -w /usr/src/asterisk/testsuite $1 ./runtests.py -l
