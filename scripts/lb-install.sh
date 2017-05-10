#!/bin/bash -ex
### Script cai dat LoadBalancer
# Khai bao bien cho cac script 
cat <<EOF> /root/lb-config.cfg
## Hostname
### Hostname cho cac may LoadBalancer
LB1_HOSTNAME=lb1
LB2_HOSTNAME=lb2


##IP Address
### IP cho bond0 cho cac may LoadBalancer
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

###MAT KHAU

EOF

source lb-config.cfg 

function echocolor {
    echo "#######################################################################"
    echo "$(tput setaf 3)##### $1 #####$(tput sgr0)"
    echo "#######################################################################"

}

function copykey {
        ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
        for IP_ADD in $LB1_IP_NIC3 $LB2_IP_NIC3
        do
                ssh-copy-id -o StrictHostKeyChecking=no -i /root/.ssh/id_rsa.pub root@$IP_ADD
        done
}

function setup_config {
        for IP_ADD in $LB1_IP_NIC3 $LB2_IP_NIC3
        do
                scp /root/lb-config.cfg root@$IP_ADD:/root/
                chmod +x lb-config.cfg
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
        source lb-config.cfg
        echo "$LB1_IP_NIC3 $LB1_HOSTNAME" >> /etc/hosts
        echo "$LB2_IP_NIC3 $LB2_HOSTNAME" >> /etc/hosts
        scp /etc/hosts root@$LB2_IP_NIC3:/etc/
                
}

function install_nginx {
        yum install -y wget 
        yum install -y epel-release
        yum --enablerepo=epel -y install nginx
        systemctl start nginx 
        systemctl enable nginx
        IP
cat << EOF > /usr/share/nginx/html/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
\$IP_ADD-`hostname`
`ip -o -4 addr show dev eth0 | sed 's/.* inet \([^/]*\).*/\1/'`
</div>
</body>
</html>
EOF
        systemctl restart nginx 
}

function install_pacemaker_corosync {
        source lb-config.cfg
        yum -y install pacemaker pcs
        systemctl start pcsd 
        systemctl enable pcsd
        echo $PASS_CLUSTER | passwd --stdin hacluster
        
}

function config_cluster {
        source lb-config.cfg
        pcs cluster auth $LB1_HOSTNAME $LB2_HOSTNAME -u hacluster -p $PASS_CLUSTER --force
        pcs cluster setup --name ha_cluster $LB1_HOSTNAME $LB2_HOSTNAME
        pcs cluster start --all
        pcs cluster enable --all
        pcs property set stonith-enabled=false
        pcs property set default-resource-stickiness="INFINITY"       
}

############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Cai dat lb"
sleep 3

echocolor "Tao key va copy key, bien khai bao sang cac node"
sleep 3
copykey
setup_config

echocolor "install_proxy, install_repo "
sleep 3

for IP_ADD in $LB1_IP_NIC3 $LB2_IP_NIC3
do 
    echocolor "Cai dat proxy tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_proxy"
    
    echocolor "Cai dat install_repo tren $IP_ADD"
    sleep 3
    ssh root@$IP_ADD "$(typeset -f); install_repo"
    
    if [ "$IP_ADD" == "$LB1_IP_NIC3" ]; then
      echocolor "Cai dat khai_bao_host tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); khai_bao_host"
    fi
      echocolor "Cai dat install_nginx tren $IP_ADD"
      sleep 3
      ssh root@$IP_ADD "$(typeset -f); install_nginx"
done 

for IP_ADD in $LB1_IP_NIC3 $LB2_IP_NIC3
do 
echocolor "Cai dat install_pacemaker_corosync tren $IP_ADD"
sleep 3
ssh root@$IP_ADD "$(typeset -f); install_pacemaker_corosync"    
done 

echocolor "Done"