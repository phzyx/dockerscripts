FROM centos:centos7

# pull centos seven then install build prereqs

# core
RUN yum -y install git wget
RUN yum -y groupinstall core base "Development Tools"
RUN yum -y install python3 python3-pip python3-devel
RUN yum -y install libedit-devel libpcap-devel openssl-devel lksctp-tools-devel gsl-devel lua-devel
# extras
RUN yum -y install epel-release

# optionally, but now's the time
RUN yum -y update

# set python 3 as defailt
RUN rm /usr/bin/python
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN ln -s /usr/bin/pip3 /usr/bin/pip
# pip installed manually
# DO NOT run the testsuite install prereq as it will install a no bueno version of pip
#WORKDIR /usr/src
#RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
#RUN python get-pip.py
RUN pip3 install twisted
RUN pip3 install construct
RUN pip3 install Cython

# make directories
WORKDIR /usr/src
# created to mount volume or bind later
RUN mkdir asterisk
RUN mkdir ast-tools
RUN mkdir ast-output

# install requirements
WORKDIR /usr/src/ast-tools
RUN git clone https://github.com/asterisk/yappcap.git
WORKDIR /usr/src/ast-tools/yappcap
#RUN make
#RUN make install

# Old sipp downloads based on tags no longer recommended
WORKDIR /usr/src/ast-tools
RUN wget https://github.com/SIPp/sipp/releases/download/v3.6.0/sipp-3.6.0.tar.gz
RUN tar -xf sipp-3.6.0.tar.gz
WORKDIR /usr/src/ast-tools/sipp-3.6.0
RUN ./build.sh --prefix=/usr --with-openssl --with-pcap --with-rtpstream --with-sctp --with-gsl CFLAGS=-w
RUN make install

WORKDIR /usr/src/ast-tools
RUN git clone https://github.com/asterisk/starpy.git
WORKDIR /usr/src/ast-tools/starpy

# Ready to rock and roll
WORKDIR /usr/src/asterisk