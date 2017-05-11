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
DB1_IP_NIC1=10.10.10.51
DB2_IP_NIC1=10.10.10.52
DB3_IP_NIC1=10.10.10.53

### IP cho bond1 cho cac may DB
DB1_IP_NIC2=192.168.20.52
DB2_IP_NIC2=192.168.20.52
DB3_IP_NIC2=192.168.20.52

### Password cho MariaDB
PASS_DATABASE_ROOT=Ec0net@!2017
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

function install_repo {
        yum -y install centos-release-openstack-newton
        yum -y upgrade
}

function install_repo_galera {
echo '[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.1/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1' >> /etc/yum.repos.d/MariaDB.repo
}

function khai_bao_host {
        source db-config.cfg
        echo "$DB1_IP_NIC2 db1" >> /etc/hosts
        echo "$DB2_IP_NIC2 db2" >> /etc/hosts
        echo "$DB3_IP_NIC2 db3" >> /etc/hosts
        scp /etc/hosts root@$DB2_IP_NIC2:/etc/
        scp /etc/hosts root@$DB3_IP_NIC2:/etc/
}

function install_mariadb_galera {
        yum -y install mariadb-server rsync xinetd crudini
}


function set_pass_db {
source db-config.cfg
HOSTNAME_DB=`hostname`
cat << EOF | mysql -uroot
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$PASS_DATABASE_ROOT';FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$PASS_DATABASE_ROOT';FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'$HOSTNAME_DB' IDENTIFIED BY '$PASS_DATABASE_ROOT';FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '$PASS_DATABASE_ROOT';FLUSH PRIVILEGES;
GRANT PROCESS ON *.* TO 'clustercheckuser'@'localhost' IDENTIFIED BY '$PASS_DATABASE_ROOT'; FLUSH PRIVILEGES;
EOF
}

function config_galera_cluster {
        source db-config.cfg
        HOSTNAME_DB=`hostname`
        cp /etc/my.cnf.d/server.cnf  /etc/my.cnf.d/server.cnf.orig
        ops_edit /etc/my.cnf.d/server.cnf galera wsrep_on ON
        ops_edit /etc/my.cnf.d/server.cnf galera wsrep_provider /usr/lib64/galera/libgalera_smm.so
        ops_edit /etc/my.cnf.d/server.cnf galera wsrep_cluster_address "gcomm://$DB1_IP_NIC1,$DB2_IP_NIC1,$DB3_IP_NIC1" 
        ops_edit /etc/my.cnf.d/server.cnf galera binlog_format row
        ops_edit /etc/my.cnf.d/server.cnf galera default_storage_engine InnoDB
        ops_edit /etc/my.cnf.d/server.cnf galera innodb_autoinc_lock_mode 2
        ops_edit /etc/my.cnf.d/server.cnf galera wsrep_cluster_name "linoxide_cluster"
        ops_edit /etc/my.cnf.d/server.cnf galera bind-address 0.0.0.0
        ops_edit /etc/my.cnf.d/server.cnf galera wsrep_node_address "$IP_ADD"
        ops_edit /etc/my.cnf.d/server.cnf galera wsrep_node_name "$HOSTNAME_DB"
        ops_edit /etc/my.cnf.d/server.cnf galera wsrep_sst_method rsync

}


############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Cai dat MariaDB, Galera"
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
    ssh root@$IP_ADD "$(typeset -f); install_repo_galera"
    
    if [ "$IP_ADD" == "$DB1_IP_NIC2" ]; then
      echocolor "Cai dat khai_bao_host tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); khai_bao_host"
    fi 
done 

echocolor " Cai dat MariaDBm galera "
sleep 3
for IP_ADD in $DB1_IP_NIC2 $DB2_IP_NIC2 $DB3_IP_NIC2
do 
    echocolor "Cai dat install_mariadb_galera tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_mariadb_galera"   
    if [ "$IP_ADD" == "$DB1_IP_NIC2" ]; then
      echocolor "Thuc hien script set_pass_db tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); set_pass_db"
    fi
    echocolor "Thuc hien script config_galera_cluster tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); config_galera_cluster"
    
done 

echocolor "Khoi dong MariaDB Cluster "
sleep 3
for IP_ADD in $DB1_IP_NIC2 $DB2_IP_NIC2 $DB3_IP_NIC2
do 
    if [ "$IP_ADD" == "$DB1_IP_NIC2" ]; then
      echocolor "Thuc hien khoi dong cluster DB $IP_ADD"
      sleep 3
      galera_new_cluster
      
    else
      systemctl start mariadb
    fi
done 
echocolor DONE
