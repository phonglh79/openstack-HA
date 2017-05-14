#!/bin/bash -ex 
##############################################################################
### Script cai dat cac goi bo tro cho CTL

### Khai bao bien de thuc hien

cat <<EOF >> /root/db-config.cfg
## Hostname
### Hostname cho cac may DB
DB1_HOSTNAME=db1
DB2_HOSTNAME=db2
DB3_HOSTNAME=db3

## IP Address
### IP cho bond0 cho cac may DB
DB1_IP_NIC1=10.10.10.51
DB2_IP_NIC1=10.10.10.52
DB3_IP_NIC1=10.10.10.53

### IP cho bond1 cho cac may DB
DB1_IP_NIC2=192.168.20.51
DB2_IP_NIC2=192.168.20.52
DB3_IP_NIC2=192.168.20.53

### Password cho MariaDB
PASS_DATABASE_ROOT=Ec0net@!2017
PASS_DATABASE_KEYSTONE=PASS_DATABASE_ROOT
PASS_DATABASE_NOVA=PASS_DATABASE_ROOT
PASS_DATABASE_NOVA_API=PASS_DATABASE_ROOT
PASS_DATABASE_NEUTRON=PASS_DATABASE_ROOT
PASS_DATABASE_GLANCE=PASS_DATABASE_ROOT
PASS_DATABASE_CEILOMTER=PASS_DATABASE_ROOT
PASS_DATABASE_AODH=PASS_DATABASE_ROOT
PASS_DATABASE_GNOCCHI=PASS_DATABASE_ROOT

EOF

chmod +x db-config.cfg
source db-config.cfg
source ctl-config.cfg

function echocolor {
    echo "#######################################################################"
    echo "$(tput setaf 3)##### $1 #####$(tput sgr0)"
    echo "#######################################################################"

}

function ops_edit {
    crudini --set $1 $2 $3 $4
}

# Cach dung
## Cu phap:
##			ops_edit_file $bien_duong_dan_file [SECTION] [PARAMETER] [VALUAE]
## Vi du:
###			filekeystone=/etc/keystone/keystone.conf
###			ops_edit_file $filekeystone DEFAULT rpc_backend rabbit


# Ham de del mot dong trong file cau hinh
function ops_del {
    crudini --del $1 $2 $3
}

function create_keystone_db {
mysql -uroot -p$PASS_DATABASE_ROOT -h $DB1_IP_NIC2 -e "CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '"$PASS_DATABASE_KEYSTONE"';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '"$PASS_DATABASE_KEYSTONE"';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'$DB1_HOSTNAME' IDENTIFIED BY '"$PASS_DATABASE_KEYSTONE"';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'$DB2_HOSTNAME' IDENTIFIED BY '"$PASS_DATABASE_KEYSTONE"';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'$DB3_HOSTNAME' IDENTIFIED BY '"$PASS_DATABASE_KEYSTONE"';
FLUSH PRIVILEGES;"
}

############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Cai dat Keystone"
sleep 3

echocolor "Tao DB keystone"
sleep 3
create_keystone_db