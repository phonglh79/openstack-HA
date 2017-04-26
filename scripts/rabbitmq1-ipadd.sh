#!/bin/bash 
### Script cai dat rabbitmq


echo "Khai bao repos"
sleep 3
echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
yum -y update

hostnamectl set-hostname mq1

echo "Setup IP  ens160"
nmcli c modify ens160 ipv4.addresses 10.10.10.21/24
nmcli c modify ens160 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli c modify ens224 ipv4.addresses 192.168.20.21/24
nmcli c modify ens224 ipv4.gateway 192.168.20.254
nmcli c modify ens224 ipv4.dns 8.8.8.8
nmcli c modify ens224 ipv4.method manual
nmcli con mod ens224 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux

echo "192.168.20.21 mq1" >> /etc/hosts
echo "192.168.20.22 mq2" >> /etc/hosts
echo "192.168.20.23 mq3" >> /etc/hosts

init 6
