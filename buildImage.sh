#!/bin/bash

echo "Building base centos7 Image for asterisk and asterisk testsuite";

docker build -t testsuite/centos7 CentOS7