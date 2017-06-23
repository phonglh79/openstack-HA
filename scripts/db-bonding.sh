#!/bin/bash -ex 
##############################################################################
### Script cai dat bonding

### Khai bao bien de thuc hien
### Kiem tra cu phap khi thuc hien shell 
if [ $# -ne 3 ]
    then
        echo -e "Nhap du 3 thong so: \e[38;5;82m DB1_HOSTNAME, \e[38;5;31m DB1_IP_NIC1,\e[38;5;11m DB1_IP_NIC2 \e[0m"
        echo ""
        echo -e "Thuc hien tren may chu DB1: \e[31m bash $0 DB1_HOSTNAME DB1_IP_NIC1 DB1_IP_NIC2 \e[0m"
        echo -e "Thuc hien tren may chu DB2: \e[31m bash $0 DB2_HOSTNAME DB2_IP_NIC1 DB2_IP_NIC2 \e[0m"
        echo -e "Thuc hien tren may chu DB3: \e[31m bash $0 DB3_HOSTNAME DB3_IP_NIC1 DB3_IP_NIC2 \e[0m"
        echo ""
        echo -e "Vi du:\e[101mbash $0 DB1 10.10.10.51 192.168.20.51 \e[0m"
        exit 1;
fi

# read -p "Nhap ten host: " HOST_NAME
# read -p "Nhap ip cho BOND0: " BOND0_IP
# read -p "Nhap ip cho BOND1: " BOND1_IP

#Khai bao cac bien su dung trong script
##Bien cho bond0
INTERFACE1=ens160
INTERFACE2=ens192
BOND0_NIC=bond0
BOND0_IP=$2
BOND0_NETMASK=24

## Bien cho bond1
INTERFACE3=ens224
INTERFACE4=ens256
BOND1_NIC=bond1
BOND1_IP=$3
BOND1_NETMASK=24
BOND1_DEAFAUL_GATEWAY=192.168.20.254
BOND1_DNS=8.8.8.8

echo "Dat hostname"
hostnamectl set-hostname $1

echo "Cau hinh bond0"
nmcli con add type bond con-name $BOND0_NIC ifname $BOND0_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND0_NIC-$INTERFACE1  ifname $INTERFACE1 master $BOND0_NIC
nmcli con add type bond-slave con-name $BOND0_NIC-$INTERFACE2 ifname $INTERFACE2 master $BOND0_NIC
nmcli con up $BOND0_NIC-$INTERFACE1
nmcli con up $BOND0_NIC-$INTERFACE2
nmcli con up $BOND0_NIC

nmcli con modify $BOND0_NIC ipv4.addresses $BOND0_IP/$BOND0_NETMASK
nmcli con modify $BOND0_NIC ipv4.method manual
nmcli con modify $BOND0_NIC connection.autoconnect yes

echo "Cau hinh BOND1"

nmcli con add type bond con-name $BOND1_NIC ifname $BOND1_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND1_NIC-$INTERFACE3  ifname $INTERFACE3 master $BOND1_NIC
nmcli con add type bond-slave con-name $BOND1_NIC-$INTERFACE4 ifname $INTERFACE4 master $BOND1_NIC
nmcli con up $BOND1_NIC-$INTERFACE3
nmcli con up $BOND1_NIC-$INTERFACE4
nmcli con up $BOND1_NIC

nmcli con modify $BOND1_NIC ipv4.addresses $BOND1_IP/$BOND1_NETMASK
nmcli con modify $BOND1_NIC ipv4.dns $BOND1_DNS
nmcli con modify $BOND1_NIC ipv4.gateway $BOND1_DEAFAUL_GATEWAY
nmcli con modify $BOND1_NIC ipv4.method manual
nmcli con modify $BOND1_NIC connection.autoconnect yes

sed -i 's/BONDING_OPTS=mode=active-backup/BONDING_OPTS="mode=active-backup miimon=100"/g'  /etc/sysconfig/network-scripts/ifcfg-$BOND0_NIC
sed -i 's/BONDING_OPTS=mode=active-backup/BONDING_OPTS="mode=active-backup miimon=100"/g'  /etc/sysconfig/network-scripts/ifcfg-$BOND1_NIC

nmcli con del $INTERFACE1 $INTERFACE2 $INTERFACE3 $INTERFACE4 

echo "Vo hieu hoa firewall va reboot may"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
sudo systemctl restart network
init 6


