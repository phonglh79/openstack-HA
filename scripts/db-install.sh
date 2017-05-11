#!/bin/bash -ex
### Script cai dat rabbitmq tren mq1
# Khai bao bien cho cac script 
cat <<EOF> /root/db-config.cfg
## Hostname
### Hostname cho cac may DB
DB1_HOSTNAME=db1
DB2_HOSTNAME=db2
DB3_HOSTNAME=db3

## IP Address
### IP cho bond0 cho cac may DB
DB1_IP_NIC1=10.10.10.41
DB2_IP_NIC1=10.10.10.42
DB3_IP_NIC1=10.10.10.43

### IP cho bond1 cho cac may DB
DB1_IP_NIC2=192.168.20.41
DB2_IP_NIC2=192.168.20.42
DB3_IP_NIC2=192.168.20.43
EOF

source db-config.cfg 

function setup_config {
        for IP_ADD in $DB1_IP_NIC2 $DB2_IP_NIC2 $DB3_IP_NIC2
        do
                scp /root/db-config.cfg root@$IP_ADD:/root/
                chmod +x db-config.cfg 
        done
}

##Bien cho hostname

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

function copykey() {
        ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
        for IP_ADD in $DB1_IP_NIC2 $DB2_IP_NIC2 $DB3_IP_NIC2
        do
                ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$IP_ADD
        done
}

function install_proxy() {
        echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
        yum -y update
}

function install_repo() {
        yum -y install centos-release-openstack-newton
        yum -y upgrade
}

function khai_bao_host() {
                source db-config.cfg
                echo "$DB1_IP_NIC2 db1" >> /etc/hosts
                echo "$DB2_IP_NIC2 db2" >> /etc/hosts
                echo "$DB3_IP_NIC2 db3" >> /etc/hosts
                scp /etc/hosts root@$DB2_IP_NIC2:/etc/
                scp /etc/hosts root@$DB3_IP_NIC2:/etc/
}



############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Cai dat rabbitmq"
sleep 3

echocolor "Tao key va copy key, bien khai bao sang cac node"
sleep 3
copykey
setup_config


echocolor " install_proxy, install_repo "
sleep 3

for IP_ADD in $DB1_IP_NIC2 $DB2_IP_NIC2 $DB3_IP_NIC2
do 
    echocolor "Cai dat proxy tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_proxy"
    
    echocolor "Cai dat install_repo tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_repo"
    
    if [ "$IP_ADD" == "$DB1_IP_NIC2" ]; then
      echocolor "Cai dat khai_bao_host tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); khai_bao_host"
    fi 
done 

echocolor DONE
