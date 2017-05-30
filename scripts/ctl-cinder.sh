#!/bin/bash -ex 
##############################################################################
### Script cai dat cac goi bo tro cho CTL

### Khai bao bien de thuc hien

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

function cinder_create_db {
      mysql -uroot -p$PASS_DATABASE_ROOT -h $DB1_IP_NIC2 -e "CREATE DATABASE cinder;
      GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'localhost' IDENTIFIED BY '$PASS_DATABASE_CINDER';
      GRANT ALL PRIVILEGES ON cinder.* TO 'cinder'@'%' IDENTIFIED BY '$PASS_DATABASE_CINDER';

      FLUSH PRIVILEGES;"
}

function cinder_user_endpoint {
        openstack user create  cinder --domain default --password $CINDER_PASS
        openstack role add --project service --user cinder admin
        openstack service create --name cinder --description "OpenStack Block Storage" volume
         openstack service create --name cinderv2 --description "OpenStack Block Storage" volumev2
         
        openstack endpoint create --region RegionOne volume public http://$IP_VIP_API:8776/v1/%\(tenant_id\)s
        openstack endpoint create --region RegionOne volume internal http://$IP_VIP_API:8776/v1/%\(tenant_id\)s
        openstack endpoint create --region RegionOne volume admin http://$IP_VIP_API:8776/v1/%\(tenant_id\)s
         
        openstack endpoint create --region RegionOne volumev2 public http://$IP_VIP_API:8776/v2/%\(tenant_id\)s
        openstack endpoint create --region RegionOne volumev2 internal http://$IP_VIP_API:8776/v2/%\(tenant_id\)s
        openstack endpoint create --region RegionOne volumev2 admin http://$IP_VIP_API:8776/v2/%\(tenant_id\)s

}

function cinder_install {
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do
            ssh root@$IP_ADD " yum -y install openstack-cinder"
        done  

}

function cinder_config {
        ctl_cinder_conf=/etc/cinder/cinder.conf
        cp $ctl_cinder_conf $ctl_cinder_conf.orig

        ops_edit $ctl_cinder_conf DEFAULT rpc_backend rabbit
        ops_edit $ctl_cinder_conf DEFAULT auth_strategy keystone
        ops_edit $ctl_cinder_conf DEFAULT my_ip IP_ADDRESS
        ops_edit $ctl_cinder_conf DEFAULT control_exchange cinder
        ops_edit $ctl_cinder_conf DEFAULT osapi_volume_listen  \$my_ip
        ops_edit $ctl_cinder_conf DEFAULT control_exchange cinder
        ops_edit $ctl_cinder_conf DEFAULT glance_api_servers http://$IP_VIP_API:9292
        ops_edit $ctl_cinder_conf DEFAULT glance_api_version 2
        
        ops_edit $ctl_cinder_conf oslo_concurrency lock_path /var/lib/cinder/tmp
        
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3 
        do      
                echocolor "Copytile cau hinh cho $IP_ADD"
                scp $ctl_cinder_conf root@$IP_ADD:/etc/cinder/                                
        done
        
        ssh root@$CTL1_IP_NIC3 "sed -i 's/IP_ADDRESS/$CTL1_IP_NIC1/g' $ctl_cinder_conf"  
        ssh root@$CTL2_IP_NIC3 "sed -i 's/IP_ADDRESS/$CTL2_IP_NIC1/g' $ctl_cinder_conf"  
        ssh root@$CTL3_IP_NIC3 "sed -i 's/IP_ADDRESS/$CTL3_IP_NIC1/g' $ctl_cinder_conf"  
}

function cinder_syncdb {
       su -s /bin/sh -c "cinder-manage db sync" cinder

}

function cinder_enable_restart {
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do
            echocolor "Restart dich vu cinder tren $IP_ADD"
            ssh root@$IP_ADD "systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service"
            ssh root@$IP_ADD "systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service"
         done  
}

############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Bat dau cai dat CINDER"
echocolor "Tao DB CINDER"
sleep 3
cinder_create_db

echocolor "Tao user va endpoint cho CINDER"
sleep 3
cinder_user_endpoint

echocolor "Cai dat CINDER"
sleep 3
cinder_install

echocolor "Cau hinh cho CINDER"
sleep 3
cinder_config

echocolor "Dong bo DB cho CINDER"
sleep 3
cinder_syncdb

echocolor "Restart dich vu CINDER"
sleep 3
cinder_enable_restart

echocolor "Da cai dat xong CINDER"
