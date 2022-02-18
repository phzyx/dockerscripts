#!/bin/bash

echo "Attempting to attach to container: $1 and build asterisk $2";

#remove existing asterisk and testsuite
echo "removing existing asterisk and testsuite directories"
docker exec -it -w /usr/src/asterisk $1 rm -rf asterisk
docker exec -it -w /usr/src/asterisk $1 rm -rf testsute

#get asterisk and the testsuite
echo "cloning asterisk..."
docker exec -it -w /usr/src/asterisk $1 git clone "https://gerrit.asterisk.org/asterisk"
docker exec -it -w /usr/src/asterisk/asterisk $1 git checkout $2
echo "cloning testsuite..."
docker exec -it -w /usr/src/asterisk $1 git clone "https://gerrit.asterisk.org/testsuite"
docker exec -it -w /usr/src/asterisk/testsuite $1 git checkout $2

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