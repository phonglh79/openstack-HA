#!/bin/bash -ex 
##############################################################################
### Script cai dat cac goi bo tro cho CTL

### Khai bao bien de thuc hien
cat <<EOF> /root/ctl-config.cfg

## Hostname
### Hostname cho cac may CONTROLLER
CTL1_HOSTNAME=ctl1
CTL2_HOSTNAME=ctl2
CTL3_HOSTNAME=ctl3

## IP Address
### IP cho bond0 cho cac may CONTROLLER
CTL1_IP_NIC1=10.10.20.61
CTL2_IP_NIC1=10.10.20.62
CTL3_IP_NIC1=10.10.20.63

### IP cho bond1 cho cac may CONTROLLER
CTL1_IP_NIC2=10.10.10.61
CTL2_IP_NIC2=10.10.10.62
CTL3_IP_NIC2=10.10.10.63

### IP cho bond3 cho cac may CONTROLLER
CTL1_IP_NIC3=192.168.20.61
CTL2_IP_NIC3=192.168.20.62
CTL3_IP_NIC3=192.168.20.63

### IP cho bond4 cho cac may CONTROLLER
CTL1_IP_NIC4=10.10.0.61
CTL2_IP_NIC4=10.10.0.62
CTL3_IP_NIC4=10.10.0.63
EOF

chmod +x ctl-config.cfg
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

function copykey {
        ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do
                ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$IP_ADD
        done
}

function setup_config {
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do
                scp /root/ctl-config.cfg root@$IP_ADD:/root/
                chmod +x ctl-config.cfg

        done
}

function install_proxy() {
        echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
        yum -y update
}

function khai_bao_host {
        source db-config.cfg
        echo "$CTL1_IP_NIC3 ctl1" >> /etc/hosts
        echo "$CTL2_IP_NIC3 ctl2" >> /etc/hosts
        echo "$CTL3_IP_NIC3 ctl3" >> /etc/hosts
        scp /etc/hosts root@$CTL2_IP_NIC3:/etc/
        scp /etc/hosts root@$CTL3_IP_NIC3:/etc/
}


# Cai dat NTP server 
function install_ntp_server {
        source ctl-config.cfg
        yum -y install chrony
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do 
          cp /etc/chrony.conf /etc/chrony.conf.orig
          if [ "$IP_ADD" == "$CTL1_IP_NIC3" ]; then
                  echocolor "Cau hinh NTP cho `hostname`"
                  sleep 3
                  sed -i 's/server 0.centos.pool.ntp.org iburst/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/ \
# server 1.centos.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/ \
# server 2.centos.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/ \
# server 3.centos.pool.ntp.org iburst/g' /etc/chrony.conf
sed -i 's/#allow 192.168\/16/allow 192.168.20.0\/24/g' /etc/chrony.conf

          else 
                  echocolor "Cau hinh NTP cho `hostname`"
                  sed -i 's/server 0.centos.pool.ntp.org iburst/server $CTL1_IP_NIC3 iburst/g' /etc/chrony.conf
                  sed -i 's/server 1.centos.pool.ntp.org iburst/ \
# server 1.centos.pool.ntp.org iburst/g' /etc/chrony.conf
                  sed -i 's/server 2.centos.pool.ntp.org iburst/ \
# server 2.centos.pool.ntp.org iburst/g' /etc/chrony.conf
                  sed -i 's/server 3.centos.pool.ntp.org iburst/ \
# server 3.centos.pool.ntp.org iburst/g' /etc/chrony.conf
          fi 
                  echocolor "Khoi dong chrony va kiem tra ntp tren `hostname`"
                  sleep 3
                  systemctl enable chronyd.service
                  systemctl start chronyd.service
                  chronyc sources   

        done        
}

function install_repo() {
        yum -y install centos-release-openstack-newton
        yum -y upgrade
        yum -y install crudini wget
        yum -y install python-openstackclient openstack-selinux
        
}


##############################################################################
# Thuc thi cac functions
## Goi cac functions
##############################################################################
echocolor "Cai dat cac goi chuan bi tren CONTROLLER"
sleep 3

echocolor "Tao key va copy key, bien khai bao sang cac node"
sleep 3
copykey
setup_config

sleep 3

for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
do 
    echocolor "Cai dat proxy tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_proxy"
    
    echocolor "Cai dat install_repo tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_repo"  
    if [ "$IP_ADD" == "$CTL1_IP_NIC3" ]; then
      echocolor "Cai dat khai_bao_host tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); khai_bao_host"
    fi 
done 

# Cai dat NTP 
install_ntp_server

###
echocolor "DONE"