# Start

FROM centos:7

# Obligatory update
RUN yum update -y

# Required for gssntlmssp
RUN yum install -y epel-release

# Update now that we have epel-release
RUN yum update -y

# Install libraries for NTLM support
RUN yum install -y gssntlmssp

# start install Python and SQLLite

RUN yum -y install yum-utils
RUN yum -y groupinstall development
RUN yum -y install wget openssl-devel sqlite-devel libffi-devel bzip2-devel libzip-devel xz-devel lzma-sdk-devel uuid-devel readline-devel ncurses-devel nc nano

RUN wget https://www.python.org/ftp/python/3.7.3/Python-3.7.3.tar.xz
RUN tar xJf Python-3.7.3.tar.xz
RUN ./Python-3.7.3/configure
RUN make && make install

ENV PATH="/root/opt/python-3.7.3/bin:${PATH}"
RUN export PATH

RUN wget https://www.sqlite.org/2019/sqlite-autoconf-3290000.tar.gz
RUN tar zxvf sqlite-autoconf-3290000.tar.gz
RUN ./sqlite-autoconf-3290000/configure --prefix=/root/opt/sqlite

RUN make && make install

ENV PATH="/root/opt/sqlite/bin:${PATH}"
RUN export PATH
ENV LD_LIBRARY_PATH="/root/opt/sqlite/lib"
RUN export LD_LIBRARY_PATH
ENV LD_RUN_PATH="/root/opt/sqlite/lib"
RUN export LD_RUN_PATH

RUN curl https://bootstrap.pypa.io/get-pip.py | python3.7

# stop install Python and SQLLite

# set work directory
WORKDIR /usr/src/app

# set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# install dependencies
RUN pip3 install --upgrade pip
COPY ./requirements.txt /usr/src/app/requirements.txt
RUN pip3 install -r requirements.txt


# copy entrypoint.sh
COPY ./entrypoint.sh /usr/src/app/entrypoint.sh

COPY ./ssh_config /etc/ssh/ssh_config

# copy project
COPY . /usr/src/app/

COPY ./id_rsa /usr/src/id_rsa

RUN chmod 700 /usr/src/id_rsa

# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

