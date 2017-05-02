#!/bin/bash -ex 
##############################################################################
### Script cai dat bonding

### Khai bao bien de thuc hien

source config.cfg

### Kiem tra cu phap khi thuc hien shell 
if [ $# -ne 1 ]
    then
        echo  "Cu phap dung nhu sau "
        echo "Thuc hien tren may chu MQ1: bash $0 mq1"
        echo "Thuc hien tren may chu MQ2: bash $0 mq2"
        echo "Thuc hien tren may chu MQ3: bash $0 mq3"
        exit 1;
fi

# read -p "Nhap ten host: " HOST_NAME
# read -p "Nhap ip cho BOND0: " BOND0_IP
# read -p "Nhap ip cho BOND1: " BOND1_IP

#Khai bao cac bien su dung trong script
##Bien cho bond0
NIC1=ens160
NIC2=ens192
BOND0_NIC=bond0
BOND0_IP=${BOND0_IP:-10.10.10.21}
BOND0_NETMASK=24

## Bien cho bond1
NIC3=ens224
NIC4=ens256
BOND1_NIC=bond1
BOND1_IP=${BOND1_IP:-192.168.20.21}
BOND1_NETMASK=24
BOND1_DEAFAUL_GATEWAY=192.168.20.254
BOND1_DNS=8.8.8.8

echo "Dat hostname"
hostnamectl set-hostname $1

echo "Cau hinh bond0"
nmcli con del $NIC1 $NIC2
nmcli con add type bond con-name $BOND0_NIC ifname $BOND0_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND0_NIC-$NIC1  ifname $NIC1 master $BOND0_NIC
nmcli con add type bond-slave con-name $BOND0_NIC-$NIC2 ifname $NIC2 master $BOND0_NIC
nmcli con up $BOND0_NIC-$NIC1
nmcli con up $BOND0_NIC-$NIC2
nmcli con up $BOND0_NIC

nmcli con modify $BOND0_NIC ipv4.addresses $BOND0_IP/$BOND0_NETMASK
nmcli con modify $BOND0_NIC ipv4.method manual
nmcli con modify $BOND0_NIC connection.autoconnect yes

echo "Cau hinh BOND1"
nmcli con del $NIC3 $NIC4
nmcli con add type bond con-name $BOND1_NIC ifname $BOND1_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND1_NIC-$NIC3  ifname $NIC3 master $BOND1_NIC
nmcli con add type bond-slave con-name $BOND1_NIC-$NIC4 ifname $NIC4 master $BOND1_NIC
nmcli con up $BOND1_NIC-$NIC3
nmcli con up $BOND1_NIC-$NIC4
nmcli con up $BOND1_NIC

nmcli con modify $BOND1_NIC ipv4.addresses $BOND1_IP/$BOND1_NETMASK
nmcli con modify $BOND1_NIC ipv4.dns $BOND1_DNS
nmcli con modify $BOND1_NIC ipv4.gateway $BOND1_DEAFAUL_GATEWAY
nmcli con modify $BOND1_NIC ipv4.method manual
nmcli con modify $BOND1_NIC connection.autoconnect yes

echo "Vo hieu hoa firewall va reboot may"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
init 6


