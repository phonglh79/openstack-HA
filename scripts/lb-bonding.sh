#!/bin/bash -ex 
##############################################################################
### Script cai dat bonding

### Khai bao bien de thuc hien
### Kiem tra cu phap khi thuc hien shell 
if [ $# -ne 3 ]
    then
        echo -e "Nhap du 5 thong so: \e[38;5;82m HOSTNAME, NIC1 NIC2 NIC3 NIC4 \e[0m"
        echo ""
        echo -e "Thuc hien tren may chu LB1: \e[31m bash $0 LB1_HOSTNAME LB1_IP_NIC1 LB1_IP_NIC2 LB1_IP_NIC3 LB1_IP_NIC4 \e[0m"
        echo -e "Thuc hien tren may chu LB1: \e[31m bash $0 LB2_HOSTNAME LB2_IP_NIC1 LB2_IP_NIC2 LB2_IP_NIC3 LB2_IP_NIC4 \e[0m"
        echo ""
        echo -e "Vi du:\e[101mbash $0 lb1 10.10.20.31 10.10.10.31 192.168.20.31 192.168.40.41 \e[0m"
        exit 1;
fi

#Khai bao cac bien su dung trong script
##Bien cho bond0
INTERFACE1=ens160
INTERFACE2=ens192
BOND0_NIC=bond0
BOND0_IP=$2
BOND0_NETMASK=24

##Bien cho bond1
INTERFACE3=ens224
INTERFACE4=ens256
BOND1_NIC=bond1
BOND1_IP=$3
BOND1_NETMASK=24

## Bien cho bond2
INTERFACE5=ens161
INTERFACE6=ens193
BOND2_NIC=bond2
BOND2_IP=$4
BOND2_NETMASK=24
BOND2_DEAFAUL_GATEWAY=192.168.20.254
BOND2_DNS=8.8.8.8

##Bien cho bond3
INTERFACE7=ens225
INTERFACE8=ens257
BOND3_NIC=bond1
BOND3_IP=$5
BOND3_NETMASK=24

echo "Dat hostname"
hostnamectl set-hostname $1

echo "Cau hinh bond0"
nmcli con del $INTERFACE1 $INTERFACE2
nmcli con add type bond con-name $BOND0_NIC ifname $BOND0_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND0_NIC-$INTERFACE1  ifname $INTERFACE1 master $BOND0_NIC
nmcli con add type bond-slave con-name $BOND0_NIC-$INTERFACE2 ifname $INTERFACE2 master $BOND0_NIC
nmcli con up $BOND0_NIC-$INTERFACE1
nmcli con up $BOND0_NIC-$INTERFACE2
nmcli con up $BOND0_NIC

nmcli con modify $BOND0_NIC ipv4.addresses $BOND0_IP/$BOND0_NETMASK
nmcli con modify $BOND0_NIC ipv4.method manual
nmcli con modify $BOND0_NIC connection.autoconnect yes

echo "Cau hinh bond1"
nmcli con del $INTERFACE3 $INTERFACE4
nmcli con add type bond con-name $BOND1_NIC ifname $BOND1_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND1_NIC-$INTERFACE3 ifname $INTERFACE3 master $BOND1_NIC
nmcli con add type bond-slave con-name $BOND1_NIC-$INTERFACE4 ifname $INTERFACE4 master $BOND1_NIC
nmcli con up $BOND1_NIC-$INTERFACE3
nmcli con up $BOND1_NIC-$INTERFACE4
nmcli con up $BOND1_NIC

nmcli con modify $BOND1_NIC ipv4.addresses $BOND1_IP/$BOND1_NETMASK
nmcli con modify $BOND1_NIC ipv4.method manual
nmcli con modify $BOND1_NIC connection.autoconnect yes


echo "Cau hinh BOND2"
nmcli con del $INTERFACE5 $INTERFACE6
nmcli con add type bond con-name $BOND2_NIC ifname $BOND2_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND2_NIC-$INTERFACE5 ifname $INTERFACE5 master $BOND2_NIC
nmcli con add type bond-slave con-name $BOND2_NIC-$INTERFACE6 ifname $INTERFACE6 master $BOND2_NIC
nmcli con up $BOND2_NIC-$INTERFACE5
nmcli con up $BOND2_NIC-$INTERFACE6
nmcli con up $BOND2_NIC

nmcli con modify $BOND2_NIC ipv4.addresses $BOND2_IP/$BOND2_NETMASK
nmcli con modify $BOND2_NIC ipv4.dns $BOND2_DNS
nmcli con modify $BOND2_NIC ipv4.gateway $BOND2_DEAFAUL_GATEWAY
nmcli con modify $BOND2_NIC ipv4.method manual
nmcli con modify $BOND2_NIC connection.autoconnect yes

echo "Cau hinh bond3"
nmcli con del $INTERFACE7 $INTERFACE8
nmcli con add type bond con-name $BOND3_NIC ifname $BOND3_NIC mode active-backup
nmcli con add type bond-slave con-name $BOND3_NIC-$INTERFACE7 ifname $INTERFACE7 master $BOND3_NIC
nmcli con add type bond-slave con-name $BOND3_NIC-$INTERFACE8 ifname $INTERFACE8 master $BOND3_NIC
nmcli con up $BOND3_NIC-$INTERFACE7
nmcli con up $BOND3_NIC-$INTERFACE8
nmcli con up $BOND3_NIC

nmcli con modify $BOND3_NIC ipv4.addresses $BOND3_IP/$BOND3_NETMASK
nmcli con modify $BOND3_NIC ipv4.method manual
nmcli con modify $BOND3_NIC connection.autoconnect yes
##########


echo "Vo hieu hoa firewall va reboot may"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
init 6


