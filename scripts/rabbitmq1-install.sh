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
if [ $# -ne 1 ]; then
        echo  "Cu phap dung nhu sau "
        echo "Thuc hien tren may chu MQ1: bash $0 mq1"
        echo "Thuc hien tren may chu MQ2: bash $0 mq2"
        echo "Thuc hien tren may chu MQ3: bash $0 mq3"
        exit 1;
fi

function copykey {
        ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
        for IP_ADD in $MQ1_IP_BOND1 $MQ1_IP_BOND1 $MQ1_IP_BOND1
        do
        ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$IP_ADD
        done
}


function install_proxy {
        echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
        yum -y update
}

function install_repo {
        yum -y install centos-release-openstack-newton
        yum -y upgrade
}

function khai_bao_host {
        if [ "$1" == "mq1" ]; then
                echo "$MQ1_IP_BOND1 mq1" >> /etc/hosts
                echo "$MQ2_IP_BOND1 mq2" >> /etc/hosts
                echo "$MQ3_IP_BOND1 mq3" >> /etc/hosts
                scp /etc/hosts root@$MQ2_IP_BOND1:/etc/
                scp /etc/hosts root@$MQ3_IP_BOND1:/etc/
        else 
                echo "Khong can khai bao"
        fi 
}

function install_rabbitmq {
        yum -y install rabbitmq-server
        systemctl enable rabbitmq-server.service
        systemctl start rabbitmq-server.service
}


function config_rabbitmq {
        if [ "$1" == "mq1" ]; then
                rabbitmqctl add_user openstack Welcome123
                rabbitmqctl set_permissions openstack ".*" ".*" ".*"
                rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'          
                echo "Da cai dat xong rabbitmq tren MQ1"
                scp /var/lib/rabbitmq/.erlang.cookie root@$MQ2_IP_BOND1:/var/lib/rabbitmq/.erlang.cookie
                scp /var/lib/rabbitmq/.erlang.cookie root@$MQ3_IP_BOND1:/var/lib/rabbitmq/.erlang.cookie
                rabbitmqctl start_app
        else 
                echo "Khong phai node rabbitmq1"
        fi
}

function install_rabbitmq_join {
        ssh root@$IP_ADD
        chown rabbitmq:rabbitmq /var/lib/rabbitmq/.erlang.cookie
        chmod 400 /var/lib/rabbitmq/.erlang.cookie
        systemctl enable rabbitmq-server.service
        systemctl start rabbitmq-server.service
        rabbitmqctl stop_app
        rabbitmqctl join_cluster rabbit@$MQ1_HOSTNAME
        rabbitmqctl start_app
        fi         
}

############################
# Thuc thi cac functions
## Goi cac functions
############################
echo "Cai dat rabbitmq"
sleep 5

###
echo "Tao key va copy key sang cac node"
sleep 5
copykey

