#!/bin/bash -ex
### Script cai dat rabbitmq tren mq1
# Khai bao bien cho cac script 

source db-config.cfg 

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

function keystone_db {
        source db-config.cfg
        mysql -uroot -p$PASS_DATABASE_KEYSTONE -e "CREATE DATABASE keystone;
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
echocolor "THUC HIEN TAO DB"
sleep 3

keystone_db

echocolor DONE
