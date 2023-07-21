#!/bin/bash

target="EDDL"

if [ $# -ge 1 ]
then
    target="${1}"
fi

apt update -y
apt upgrade -y
echo "Europe/Madrid" >/etc/timezone
ln -fs /usr/share/zoneinfo/Europe/Madrid /etc/localtime
# ENV DEBIAN_FRONTEND=noninteractive
# RUN echo 'tzdata tzdata/Areas select Europe' | debconf-set-selections
# RUN echo 'tzdata tzdata/Zones/Europe select Madrid' | debconf-set-selections
# RUN DEBIAN_FRONTEND="noninteractive" apt install -y tzdata
apt install -y tzdata 
dpkg-reconfigure --frontend noninteractive tzdata

apt install -y build-essential ca-certificates apt-utils
apt install -y net-tools tree openssh-server rsync
apt install -y vim
apt install -y git wget curl 
apt install -y g++ cmake make

mkdir /root/.ssh && cd /root/.ssh && ssh-keygen -f id_rsa -t rsa -N ""
cd /root/.ssh && cat id_rsa.pub >>authorized_keys
if [ -f /installation/id_rsa.pub-user-to-access ]
then
    cat /installation/id_rsa.pub-user-to-access >>/root/.ssh/authorized_keys
    rm -r /installation/id_rsa.pub-user-to-access
fi

echo "PermitRootLogin yes" >>/etc/ssh/sshd_config
echo "Port 2022" >>/etc/ssh/sshd_config

apt install -y opensbi u-boot-qemu

# Prepare the SSH server daemon in the container
cp /installation/init.sh /usr/local/bin/
chmod u+x /usr/local/bin/init.sh
