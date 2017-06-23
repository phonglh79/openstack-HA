#!/bin/bash -ex 
##############################################################################
### Script cai dat cac goi bo tro cho CTL

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
echocolor "Cai dat repo cho Galera"
sleep 3
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo

yum -y upgrade
}

function install_repo {
        echocolor "Cai dat repo cho OpenStack"
        sleep 3
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
        echo "$COM1_IP_NIC4 com1" >> /etc/hosts
        echo "$COM2_IP_NIC4 com2" >> /etc/hosts
        echo "$COM3_IP_NIC4 com3" >> /etc/hosts
}

function install_ntp_server {
        yum -y install chrony       
        systemctl enable chronyd.service
        systemctl start chronyd.service
        systemctl restart chronyd.service
        echocolor "Cau hinh NTP cho `hostname`"
        sleep 5             
        sed -i "s/server 0.centos.pool.ntp.org iburst/server $CTL1_IP_NIC3 iburst/g" /etc/chrony.conf
        sed -i "s/server 1.centos.pool.ntp.org iburst/#/g" /etc/chrony.conf
        sed -i "s/server 2.centos.pool.ntp.org iburst/#/g" /etc/chrony.conf
        sed -i "s/server 3.centos.pool.ntp.org iburst/#/g" /etc/chrony.conf
        systemctl enable chronyd.service
        systemctl start chronyd.service
        systemctl restart chronyd.service
        chronyc sources
}

##############################################################################
# Thuc thi cac functions
## Goi cac functions
##############################################################################

echocolor "Bat dau cai dat cho COMPUTE"
source ctl-config.cfg

echocolor "Cai dat Proxy"
sleep 3
install_proxy

echocolor "Cai dat repos openstack va mariadb"
sleep 3
install_repo_galera
install_repo

echocolor "Khai bao hostname"
sleep 3
khai_bao_host

echocolor "Cai dat va cau hinh NTP"
sleep 3
install_ntp_server

echocolor "Reboot"
sleep 3
init 6