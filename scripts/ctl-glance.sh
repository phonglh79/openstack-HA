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

function create_glance_db {
mysql -uroot -p$PASS_DATABASE_ROOT -h $DB1_IP_NIC2 -e "CREATE DATABASE glance;
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$PASS_DATABASE_GLANCE';
GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$PASS_DATABASE_GLANCE';
FLUSH PRIVILEGES;"
}

function glance_user_endpoint {
        openstack user create  glance --domain default --password $PASS_DATABASE_GLANCE
        openstack role add --project service --user glance admin
        openstack service create --name glance --description "OpenStack Image" image
        openstack endpoint create --region RegionOne image public http://$IP_VIP_API:9292
        openstack endpoint create --region RegionOne image internal http://$IP_VIP_API:9292
        openstack endpoint create --region RegionOne image admin http://$IP_VIP_API:9292
}

function glance_install {
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do
            ssh root@$IP_ADD "yum -y install openstack-glance"
        done  

}

function glance_config {
        glance_api_conf=/etc/glance/glance-api.conf
        glance_registry_conf=/etc/glance/glance-registry.conf
        cp $glance_api_conf $glance_api_conf.orig
        cp $glance_registry_conf $glance_registry_conf.orig

        ops_edit $glance_api_conf glance_store stores file,http
        ops_edit $glance_api_conf glance_store default_store file
        ops_edit $glance_api_conf glance_store filesystem_store_datadir /var/lib/glance/images/

        ops_edit $glance_api_conf database connection mysql+pymysql://glance:$PASS_DATABASE_GLANCE@$IP_VIP_API/glance

        ops_edit $glance_api_conf keystone_authtoken auth_uri http://$IP_VIP_API:5000
        ops_edit $glance_api_conf keystone_authtoken auth_url http://$IP_VIP_API:35357
        ops_edit $glance_api_conf keystone_authtoken memcached_servers $CTL1_IP_NIC1:11211,$CTL2_IP_NIC1:11211,$CTL3_IP_NIC1:11211
        ops_edit $glance_api_conf keystone_authtoken auth_type password
        ops_edit $glance_api_conf keystone_authtoken project_domain_name default
        ops_edit $glance_api_conf keystone_authtoken user_domain_name default
        ops_edit $glance_api_conf keystone_authtoken project_name service
        ops_edit $glance_api_conf keystone_authtoken username glance
        ops_edit $glance_api_conf keystone_authtoken password $GLANCE_PASS

        ops_edit $glance_api_conf paste_deploy flavor keystone

}
function glance_syncdb {
        su -s /bin/sh -c "glance-manage db_sync" glance

}


function glance_enable_restart {
        for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
        do
            ssh root@$IP_ADD "systemctl enable openstack-glance-api.service"
            ssh root@$IP_ADD "systemctl enable openstack-glance-registry.service"
            ssh root@$IP_ADD "systemctl start openstack-glance-api.service"
            ssh root@$IP_ADD "systemctl start openstack-glance-registry.service"
        done  
}


############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Cai dat Keystone"
sleep 3

echocolor "Tao DB keystone"
sleep 3
create_keystone_db

echocolor "Cai dat keystone"
sleep 3
keystone_install

echocolor "Config keystone"
sleep 3
keystone_config

echocolor "Sync DB cho keystone"
sleep 3
keystone_syncdb

echocolor "Tao endpoint"
sleep 3
keystone_bootstrap

echocolor "Cau hinh http"
sleep 3
for IP_ADD in $CTL1_IP_NIC3 $CTL2_IP_NIC3 $CTL3_IP_NIC3
do
    echo "Cai dat keystone_config_http $IP_ADD"
    ssh root@$IP_ADD "$(typeset -f); keystone_config_http"
done

echocolor "Tao bien moi truong"
sleep 3
keystone_create_adminrc
source admin-openrc

echocolor "Tao Endpoint"
sleep 3
keystone_endpoint