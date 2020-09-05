# Start

# Docker image file that describes an CentOS7 image with PowerShell installed from Microsoft YUM Repo
ARG fromTag=7
ARG imageRepo=centos

FROM ${imageRepo}:${fromTag} AS installer-env

ARG PS_VERSION=6.2.0
ARG PACKAGE_VERSION=6.2.0
ARG PS_PACKAGE=powershell-${PACKAGE_VERSION}-1.rhel.7.x86_64.rpm
ARG PS_PACKAGE_URL=https://github.com/PowerShell/PowerShell/releases/download/v${PS_VERSION}/${PS_PACKAGE}

# Define ENVs for Localization/Globalization
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    # set a fixed location for the Module analysis cache
    PSModuleAnalysisCachePath=/var/cache/microsoft/powershell/PSModuleAnalysisCache/ModuleAnalysisCache

# Install dependencies and clean up
RUN curl -sSL ${PS_PACKAGE_URL} -o /tmp/powershell.rpm \
    && yum install -y /tmp/powershell.rpm \
    # Required for gssntlmssp
    && yum install -y epel-release \
    # Update now that we have epel-release
    && yum update -y \
    # Install libraries for NTLM support
    && yum install -y \
      gssntlmssp \
      # less is required for help in powershell
      less \
      # PowerShell remoting over SSH dependencies
      openssh-clients \
    && yum upgrade-minimal -y --security \
    && yum clean all \
    && localedef --charmap=UTF-8 --inputfile=en_US $LANG \
    # remove powershell package
    && rm /tmp/powershell.rpm \
    # intialize powershell module cache
    && pwsh \
        -NoLogo \
        -NoProfile \
        -Command " \
          \$ErrorActionPreference = 'Stop' ; \
          \$ProgressPreference = 'SilentlyContinue' ; \
          while(!(Test-Path -Path \$env:PSModuleAnalysisCachePath)) {  \
            Write-Host "'Waiting for $env:PSModuleAnalysisCachePath'" ; \
            Start-Sleep -Seconds 6 ; \
          }"

# Use PowerShell as the default shell
# Use array to avoid Docker prepending /bin/sh -c
# End

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
RUN yum -y install wget openssl-devel sqlite-devel libffi-devel bzip2-devel libzip-devel xz-devel lzma-sdk-devel uuid-devel readline-devel ncurses-devel

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

# copy project
COPY . /usr/src/app/

# run entrypoint.sh
ENTRYPOINT ["/usr/src/app/entrypoint.sh"]

