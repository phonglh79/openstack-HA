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

function ceilometer_user_endpoint {
        openstack user create ceilometer --domain default --password $CEILOMETER_PASS
        openstack role add --project service --user ceilometer admin
        openstack service create --name ceilometer --description "Telemetry" metering
         
        openstack user create gnocchi --domain default --password $GNOCCHI_PASS
        openstack service create --name gnocchi --description "Metric Service" metric
        
openstack endpoint create --region RegionOne metric public http://$IP_VIP_API:8041
openstack endpoint create --region RegionOne metric internal http://$IP_VIP_API:8041
openstack endpoint create --region RegionOne metric admin http://$IP_VIP_API:8041



}

function cinder_install {
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do
            ssh root@$IP_ADD " yum -y install openstack-cinder targetcli"
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
        ops_edit $ctl_cinder_conf DEFAULT enabled_backends lvm
        
        ops_edit $ctl_cinder_conf database connection  mysql+pymysql://cinder:$PASS_DATABASE_CINDER@$IP_VIP_DB/cinder

        ops_edit $ctl_cinder_conf keystone_authtoken auth_uri http://$IP_VIP_API:5000
        ops_edit $ctl_cinder_conf keystone_authtoken auth_url http://$IP_VIP_API:35357
        ops_edit $ctl_cinder_conf keystone_authtoken memcached_servers $CTL1_IP_NIC1:11211,$CTL2_IP_NIC1:11211,$CTL3_IP_NIC1:11211
        ops_edit $ctl_cinder_conf keystone_authtoken auth_type password
        ops_edit $ctl_cinder_conf keystone_authtoken project_domain_name Default
        ops_edit $ctl_cinder_conf keystone_authtoken user_domain_name Default
        ops_edit $ctl_cinder_conf keystone_authtoken project_name service
        ops_edit $ctl_cinder_conf keystone_authtoken username cinder
        ops_edit $ctl_cinder_conf keystone_authtoken password $CINDER_PASS
        
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_hosts $MQ1_IP_NIC1:5672,$MQ2_IP_NIC1:5672,$MQ3_IP_NIC1:5672
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_ha_queues true
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_retry_interval 1
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_retry_backoff 2
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_max_retries 0
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_durable_queues true
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_userid openstack
        ops_edit $ctl_cinder_conf oslo_messaging_rabbit rabbit_password $RABBIT_PASS
        
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
            ssh root@$IP_ADD "systemctl enable openstack-cinder-api.service openstack-cinder-scheduler.service openstack-cinder-backup.service"
            ssh root@$IP_ADD "systemctl start openstack-cinder-api.service openstack-cinder-scheduler.service openstack-cinder-backup.service"
            ssh root@$IP_ADD "systemctl enable openstack-cinder-volume.service target.service"
            ssh root@$IP_ADD "systemctl start openstack-cinder-volume.service target.service"
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
