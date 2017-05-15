#!/bin/bash -ex
### Script cau hinh resouce cho LB
# Khai bao bien cho cac script 

echo IP_VIP_API=10.10.20.30 >> lb-config.cfg 
echo IP_VIP_DB=10.10.10.30 >> lb-config.cfg 
echo IP_VIP_ADMIN=192.168.20.30 >> lb-config.cfg 

source lb-config.cfg 

function echocolor {
    echo "#######################################################################"
    echo "$(tput setaf 3)##### $1 #####$(tput sgr0)"
    echo "#######################################################################"

}

function add_resources {
        pcs resource create Virtual_IP_API ocf:heartbeat:IPaddr2 ip=$IP_VIP_API cidr_netmask=32 op monitor interval=30s
        pcs resource create Virtual_IP_DB ocf:heartbeat:IPaddr2 ip=$IP_VIP_DB cidr_netmask=32 op monitor interval=30s
        pcs resource create Web_Cluster ocf:heartbeat:nginx configfile=/etc/nginx/nginx.conf status10url op monitor interval=5s
        # pcs resource clone Web_Cluster globally-unique=true clone-max=2 clone-node-max=2
        pcs constraint colocation add Web_Cluster with Virtual_IP_API INFINITY        
        pcs constraint order Virtual_IP_API then Web_Cluster
}

#####
add_resources