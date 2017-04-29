#!/bin/bash -ex 
##############################################################################
### Script cai dat bonding

#Khai bao cac bien su dung trong script
## Bien cho bond0
read -p "Nhap ip cho BOND0: " IP_BOND0
read -p "Nhap ip cho BOND1: " IP_BOND1

NIC1=ens160
NIC2=ens192
NIC_BOND0=bond0
IP_BOND0=${IP_BOND0:-10.10.10.21}
NETMASK_BOND0=24

## Bien cho bond1
NIC3=ens224
NIC4=ens256
NIC_BOND1=bond1
IP_BOND1=${IP_BOND1:-192.168.20.21}
NETMASK_BOND1=24
BOND1_DEAFAUL_GATEWAY=192.168.20.254
BOND1_DNS=8.8.8.8


echo "Cau hinh bond0"
nmcli c del $NIC1 $NIC2
nmcli con add type bond con-name $NIC_BOND0 ifname $NIC_BOND0 mode active-backup
nmcli con add type bond-slave con-name $NIC_BOND0-$NIC1  ifname $NIC1 master $NIC_BOND0
nmcli con add type bond-slave con-name $NIC_BOND0-$NIC2 ifname $NIC2 master $NIC_BOND0
nmcli con up $NIC_BOND0-$NIC1
nmcli con up $NIC_BOND0-$NIC2
nmcli con up $NIC_BOND0

nmcli con modify $NIC_BOND0 ipv4.addresses $IP_BOND0/$NETMASK_BOND0
nmcli con modify $NIC_BOND0 ipv4.method manual
nmcli con modify $NIC_BOND0 connection.autoconnect yes

echo "Cau hinh BOND1"
nmcli c del $NIC3 $NIC4
nmcli con add type bond con-name $NIC_BOND1 ifname $NIC_BOND1 mode active-backup
nmcli con add type bond-slave con-name $NIC_BOND1-$NIC3  ifname $NIC3 master $NIC_BOND1
nmcli con add type bond-slave con-name $NIC_BOND1-$NIC4 ifname $NIC4 master $NIC_BOND1
nmcli con up $NIC_BOND1-$NIC3
nmcli con up $NIC_BOND1-$NIC4
nmcli con up $NIC_BOND1

nmcli con modify $NIC_BOND1 ipv4.addresses $IP_BOND1/$NETMASK_BOND1
nmcli con modify $NIC_BOND1 ipv4.dns $BOND1_DNS
nmcli con modify $NIC_BOND1 ipv4.gateway $BOND1_DEAFAUL_GATEWAY
nmcli con modify $NIC_BOND1 ipv4.method manual
nmcli con modify $NIC_BOND1 connection.autoconnect yes

## Sao luu file cau hinh network 
# mkdir /root/backup-file
# mv /etc/sysconfig/network-scripts/ifcfg-ens* /root/backup-file

#echo "Reload network"
#nmcli con reload
#systemctl restart network

echo "Vo hieu hoa firewall va reboot may"
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network
init 6


