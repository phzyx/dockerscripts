FROM centos:centos7

# pull centos seven then install build prereqs

# core
RUN yum -y install git wget
RUN yum -y groupinstall core base "Development Tools"
RUN yum -y install libedit-devel python-devel libpcap-devel openssl-devel lksctp-tools-devel gsl-devel lua-devel
# extras
RUN yum -y install epel-release

# optionally, but now's the time
RUN yum -y update

# pip installed manually
# DO NOT run the testsuite install prereq as it will install a no bueno version of pip
WORKDIR /usr/src
RUN curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
RUN python get-pip.py
RUN pip install twisted
RUN pip install construct
RUN pip install Cython

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
RUN make
RUN make install
#RUN make PYTHON=python2
#RUN sudo make PYTHON=python2 install

WORKDIR /usr/src/ast-tools
# Old sipp downloads based on tags no longer recommended
#RUN git clone https://github.com/SIPp/sipp.git
#RUN git checkout v3.6.0
RUN wget https://github.com/SIPp/sipp/releases/download/v3.6.0/sipp-3.6.0.tar.gz
RUN tar -xf sipp-3.6.0.tar.gz
WORKDIR /usr/src/ast-tools/sipp-3.6.0
RUN ./build.sh --prefix=/usr --with-openssl --with-pcap --with-rtpstream --with-sctp --with-gsl CFLAGS=-w
RUN make install

WORKDIR /usr/src/ast-tools
RUN git clone https://github.com/asterisk/starpy.git
WORKDIR /usr/src/ast-tools/starpy
RUN python setup.py install
#RUN python2 setup.py install

# Ready to rock and roll
WORKDIR /usr/src/asterisk