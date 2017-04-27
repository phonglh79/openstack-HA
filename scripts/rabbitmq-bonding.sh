#!/bin/bash -ex 
##############################################################################
### Script cai dat bonding

#Khai bao cac bien su dung trong script
NIC1=ens160
NIC2=ens192
NIC_BOND0=bond0

echo "Cau hinh bond0"
nmcli con add type bond con-name $NIC_BOND0 ifname $NIC_BOND0 mode active-backup
nmcli con add type bond-slave con-name $NIC_BOND0-$NIC1  ifname $NIC1 master $NIC_BOND0
nmcli con add type bond-slave con-name $NIC_BOND0-$NIC2 ifname $NIC2 master $NIC_BOND0
nmcli con up $NIC_BOND0-$NIC1
nmcli con up $NIC_BOND0-$NIC2
nmcli con up $NIC_BOND0

echo "Setup IP  $NIC_BOND0"
nmcli c modify $NIC_BOND0 ipv4.addresses 10.10.10.22/24
nmcli c modify $NIC_BOND0 ipv4.method manual
nmcli con mod $NIC_BOND0 connection.autoconnect yes