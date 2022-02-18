#!/bin/bash

echo "Attempting to attach to running container: $1 and make existing asterisk";

#build asterisk
echo "building asterisk"
docker exec -it -w /usr/src/asterisk/asterisk $1 git branch
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
echo "installing asterisk"
docker exec -it -w /usr/src/asterisk/asterisk $1 make install
docker exec -it -w /usr/src/asterisk/asterisk $1 make samples