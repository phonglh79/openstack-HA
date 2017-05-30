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

## IP Address CONTROLLER
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

### Hostname cho cac may COMPUTE
COM1_HOSTNAME=com1
COM2_HOSTNAME=com3
COM3_HOSTNAME=com3

## IP Address CONTROLLER
### IP cho NIC1 - API cho cac may COMPUTE
COM1_IP_NIC1=10.10.20.71
COM2_IP_NIC1=10.10.20.72
COM3_IP_NIC1=10.10.20.73

### IP cho NIC2 - DB_MQ cho cac may COMPUTE
COM1_IP_NIC2=10.10.10.71
COM2_IP_NIC2=10.10.10.72
COM3_IP_NIC2=10.10.10.73

### IP cho NIC3 - Provider VM cho cac may COMPUTE
COM1_IP_NIC3=192.168.50.71
COM2_IP_NIC3=192.168.50.72
COM3_IP_NIC3=192.168.50.73

### IP cho NIC4 - Provider VM cho cac may COMPUTE
COM1_IP_NIC4=192.168.20.71
COM2_IP_NIC4=192.168.20.72
COM3_IP_NIC4=192.168.20.73

### IP cho NIC5 - DATA_VM cho cac may COMPUTE
COM1_IP_NIC5=172.16.20.71
COM2_IP_NIC5=172.16.20.72
COM3_IP_NIC5=172.16.20.73

### IP cho NIC5 - COMPUTE_CEPH cho cac may COMPUTE
COM1_IP_NIC6=10.10.0.71
COM2_IP_NIC6=10.10.0.71
COM3_IP_NIC6=10.10.0.71

#########DB
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

### Hostname cho cac may rabbitmq
MQ1_HOSTNAME=mq1
MQ2_HOSTNAME=mq2
MQ3_HOSTNAME=mq3

## IP Address
### IP cho bond0 cho cac may rabbitmq
MQ1_IP_NIC1=10.10.10.41
MQ2_IP_NIC1=10.10.10.42
MQ3_IP_NIC1=10.10.10.43

### IP cho bond1 cho cac may rabbitmq
MQ1_IP_NIC2=192.168.20.41
MQ2_IP_NIC2=192.168.20.42
MQ3_IP_NIC2=192.168.20.43

### Hostname cho cac may LoadBalancer
LB1_HOSTNAME=lb1
LB2_HOSTNAME=lb2

##IP Address
### IP VIP
IP_VIP_ADMIN=192.168.20.30
IP_VIP_DB=10.10.10.30
IP_VIP_API=10.10.20.30

###IP cho bond0 cho cac may LoadBalancer
LB1_IP_NIC1=10.10.20.31
LB2_IP_NIC1=10.10.20.31

###IP cho bond1 cho cac may LoadBalancer
LB1_IP_NIC2=10.10.10.31
LB2_IP_NIC2=10.10.10.32

###IP cho bond2 cho cac may LoadBalancer
LB1_IP_NIC3=192.168.20.31
LB2_IP_NIC3=192.168.20.32

###IP cho bond3 cho cac may LoadBalancer
LB1_IP_NIC4=192.168.40.31
LB2_IP_NIC4=192.168.40.32

##MAT KHAU
PASS_CLUSTER='Ec0net#!2017'
PASS_RABBIT='Ec0net#!2017'

### Password cho MariaDB
PASS_DATABASE_ROOT='Ec0net#!2017'
PASS_DATABASE_KEYSTONE=\$PASS_DATABASE_ROOT
PASS_DATABASE_NOVA=\$PASS_DATABASE_ROOT
PASS_DATABASE_NOVA_API=\$PASS_DATABASE_ROOT
PASS_DATABASE_NEUTRON=\$PASS_DATABASE_ROOT
PASS_DATABASE_GLANCE=\$PASS_DATABASE_ROOT
PASS_DATABASE_CINDER=\$PASS_DATABASE_ROOT
PASS_DATABASE_CEILOMTER=\$PASS_DATABASE_ROOT
PASS_DATABASE_AODH=\$PASS_DATABASE_ROOT
PASS_DATABASE_GNOCCHI=\$PASS_DATABASE_ROOT

### Password openstack service
RABBIT_PASS=Welcome123
METADATA_SECRET=\$PASS_DATABASE_ROOT
ADMIN_PASS=\$PASS_DATABASE_ROOT
DEMO_PASS=\$PASS_DATABASE_ROOT
GLANCE_PASS=\$PASS_DATABASE_ROOT
NOVA_PASS=\$PASS_DATABASE_ROOT
NOVA_API_PASS=\$PASS_DATABASE_ROOT
CINDER_PASS=\$PASS_DATABASE_ROOT
NEUTRON_PASS=\$PASS_DATABASE_ROOT
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
function install_repo_galera {
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo

yum -y upgrade
}

function install_repo() {
        yum -y install centos-release-openstack-newton
        yum -y upgrade
        yum -y install crudini wget vim
        yum -y install python-openstackclient openstack-selinux
        yum -y install mariadb mariadb-server python2-PyMySQL
        
}

function khai_bao_host {
        source ctl-config.cfg
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
          echocolor "Cau hinh NTP cho IP_ADD"
          sleep 3
          cp /etc/chrony.conf /etc/chrony.conf.orig
          if [ "$IP_ADD" == "$CTL1_IP_NIC3" ]; then
                  sed -i 's/server 0.centos.pool.ntp.org iburst/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' /etc/chrony.conf
                  sed -i 's/server 1.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
                  sed -i 's/server 2.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
                  sed -i 's/server 3.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
                  sed -i 's/#allow 192.168\/16/allow 192.168.20.0\/24/g' /etc/chrony.conf
                  sleep 5                  
                  systemctl enable chronyd.service
                  systemctl start chronyd.service
                  systemctl restart chronyd.service
                  chronyc sources
          else 
                  echocolor "Cau hinh NTP cho $IP_ADD"
                  sleep 5
                  ssh root@$IP_ADD << EOF               
sed -i 's/server 0.centos.pool.ntp.org iburst/server $CTL1_IP_NIC3 iburst/g' /etc/chrony.conf
sed -i 's/server 1.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 2.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
sed -i 's/server 3.centos.pool.ntp.org iburst/#/g' /etc/chrony.conf
systemctl enable chronyd.service
systemctl start chronyd.service
systemctl restart chronyd.service
chronyc sources
EOF
          fi  
        done        
}

function install_memcached {
        yum -y install memcached python-memcached
        cp /etc/sysconfig/memcached /etc/sysconfig/memcached.orig
        IP_LOCAL=`ip -o -4 addr show dev bond2 | sed 's/.* inet \([^/]*\).*/\1/'`
        sed -i "s/-l 127.0.0.1,::1/-l 127.0.0.1,::1,$IP_LOCAL/g" /etc/sysconfig/memcached
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
    
    echocolor "Cai dat repo tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_repo_galera"  
    ssh root@$IP_ADD "$(typeset -f); install_repo"  
    if [ "$IP_ADD" == "$CTL1_IP_NIC3" ]; then
      echocolor "Cai dat khai_bao_host tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); khai_bao_host"
    fi 
done 

# Cai dat NTP 
echocolor "Cai dat Memcached tren $IP_ADD"
install_ntp_server


for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
do
    echocolor "Cai dat Memcached tren $IP_ADD"
    ssh root@$IP_ADD "$(typeset -f); install_memcached "
done 

###
echocolor "XONG & KHOI DONG LAI MAY CHU"
sleep 5
init 6