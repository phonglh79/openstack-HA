#!/bin/bash -ex
### Script cai dat rabbitmq tren mq1


#Khai bao cac bien su dung trong script
##Bien cho bond0
MQ1_IP_BOND1=192.168.20.21
MQ2_IP_BOND1=192.168.20.22
MQ3_IP_BOND1=192.168.20.23

##Bien cho hostname
MQ1_HOSTNAME=mq1
MQ2_HOSTNAME=mq2
MQ3_HOSTNAME=mq3

### Kiem tra cu phap khi thuc hien shell 

function copykey() {
        ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
        for IP_ADD in $MQ1_IP_BOND1 $MQ2_IP_BOND1 $MQ3_IP_BOND1
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
                echo "$MQ1_IP_BOND1 mq1" >> /etc/hosts
                echo "$MQ2_IP_BOND1 mq2" >> /etc/hosts
                echo "$MQ3_IP_BOND1 mq3" >> /etc/hosts
                scp /etc/hosts root@$MQ2_IP_BOND1:/etc/
                scp /etc/hosts root@$MQ3_IP_BOND1:/etc/
}

function install_rabbitmq() {
        yum -y install rabbitmq-server
        systemctl enable rabbitmq-server.service
        systemctl start rabbitmq-server.service
}

function config_rabbitmq() {
        rabbitmqctl add_user openstack Welcome123
        rabbitmqctl set_permissions openstack ".*" ".*" ".*"
        rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'          
        echo "Da cai dat xong rabbitmq tren MQ1"
        scp /var/lib/rabbitmq/.erlang.cookie root@$MQ2_IP_BOND1:/var/lib/rabbitmq/.erlang.cookie
        scp /var/lib/rabbitmq/.erlang.cookie root@$MQ3_IP_BOND1:/var/lib/rabbitmq/.erlang.cookie
        rabbitmqctl start_app

}

function rabbitmq_join_cluster() {
        ssh root@$IP_ADD
        chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
        chmod 400 /var/lib/rabbitmq/.erlang.cookie
        rabbitmqctl stop_app
        rabbitmqctl join_cluster rabbit@$MQ1_HOSTNAME
        rabbitmqctl start_app
     
}

############################
# Thuc thi cac functions
## Goi cac functions
############################
echo "Cai dat rabbitmq"
sleep 5

echo "######################################"
echo "Tao key va copy key sang cac node"
echo "######################################"
sleep 3
copykey

echo "######################################"
echo " install_proxy, install_repo "
echo "######################################"
sleep 3
for IP_ADD in $MQ1_IP_BOND1 $MQ2_IP_BOND1 $MQ3_IP_BOND1
do 
    ssh root@$IP_ADD "$(typeset -f); install_proxy"
    ssh root@$IP_ADD "$(typeset -f); install_repo"
    if [ "$IP_ADD" == "$MQ1_IP_BOND1" ]; then 
      ssh root@$IP_ADD "$(typeset -f); khai_bao_host"
    fi 
    
    ssh root@$IP_ADD "$(typeset -f); install_rabbitmq"
    
    if [ "$IP_ADD" == "$MQ1_IP_BOND1" ]; then 
      ssh root@$IP_ADD "$(typeset -f); config_rabbitmq"
    fi
    
    if [ "$IP_ADD" == "$MQ2_IP_BOND1" || "$IP_ADD" == "$MQ3_IP_BOND1"]; then
      ssh root@$IP_ADD "$(typeset -f); rabbitmq_join_cluster"
    fi 
done 

rabbitmqctl cluster_status
echo done
