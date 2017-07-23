#!/bin/bash -ex 
##############################################################################
### Script cai dat cac goi bo tro cho CTL

### Khai bao bien de thuc hien

source config.cfg

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

function aodh_create_db {
      mysql -uroot -p$PASS_DATABASE_ROOT  -e "CREATE DATABASE aodh;
      GRANT ALL PRIVILEGES ON aodh.* TO 'aodh'@'localhost' IDENTIFIED BY '$PASS_DATABASE_AODH';
      GRANT ALL PRIVILEGES ON aodh.* TO 'aodh'@'%' IDENTIFIED BY '$PASS_DATABASE_AODH';
      GRANT ALL PRIVILEGES ON aodh.* TO 'aodh'@'$CTL1_IP_NIC1' IDENTIFIED BY '$PASS_DATABASE_AODH';

      FLUSH PRIVILEGES;"
}

function aodh_user_endpoint {
        openstack user create aodh --domain default --password $AODH_PASS
        openstack role add --project service --user aodh admin
				
				openstack service create --name aodh --description "Telemetry" alarming
				openstack endpoint create --region RegionOne alarming public http://$CTL1_IP_NIC1:8042
				openstack endpoint create --region RegionOne alarming internal http://$CTL1_IP_NIC1:8042
				openstack endpoint create --region RegionOne alarming admin http://$CTL1_IP_NIC1:8042
				       
}

function aodh_install_config {
        echocolor "Cai dat AODH"
        sleep 3
        yum -y install openstack-aodh-api \
				openstack-aodh-evaluator openstack-aodh-notifier \
				openstack-aodh-listener openstack-aodh-expirer \
				python-aodhclient
				
				yum -y install mod_wsgi memcached python-memcached httpd
				
				pip install requests-aws
				
        ctl_aodh_conf=/etc/aodh/aodh.conf
        cp $ctl_aodh_conf $ctl_aodh_conf.orig

        ops_edit $ctl_aodh_conf DEFAULT rpc_backend rabbit
        ops_edit $ctl_aodh_conf DEFAULT auth_strategy keystone
        ops_edit $ctl_aodh_conf DEFAULT my_ip $CTL1_IP_NIC1
        ops_edit $ctl_aodh_conf DEFAULT DEFAULT host `hostname`
				
        
        ops_edit $ctl_aodh_conf database connection  mysql+pymysql://aodh:PASS_DATABASE_AODH@$CTL1_IP_NIC1/aodh

        ops_edit $ctl_aodh_conf keystone_authtoken auth_uri http://$CTL1_IP_NIC1:5000
        ops_edit $ctl_aodh_conf keystone_authtoken auth_url http://$CTL1_IP_NIC1:35357
        ops_edit $ctl_aodh_conf keystone_authtoken memcached_servers $CTL1_IP_NIC1:11211
        ops_edit $ctl_aodh_conf keystone_authtoken auth_type password
        ops_edit $ctl_aodh_conf keystone_authtoken project_domain_name Default
        ops_edit $ctl_aodh_conf keystone_authtoken user_domain_name Default
        ops_edit $ctl_aodh_conf keystone_authtoken project_name service
        ops_edit $ctl_aodh_conf keystone_authtoken username aodh
        ops_edit $ctl_aodh_conf keystone_authtoken password $AODH_PASS
        
        ops_edit $ctl_aodh_conf oslo_messaging_rabbit rabbit_host $CTL1_IP_NIC1
        ops_edit $ctl_aodh_conf oslo_messaging_rabbit rabbit_port 5672
        ops_edit $ctl_aodh_conf oslo_messaging_rabbit rabbit_userid openstack
        ops_edit $ctl_aodh_conf oslo_messaging_rabbit rabbit_password $RABBIT_PASS
				
        ops_edit $ctl_aodh_conf service_credentials auth_type password
        ops_edit $ctl_aodh_conf service_credentials auth_url http://$CTL1_IP_NIC1:5000/v3
        ops_edit $ctl_aodh_conf service_credentials project_domain_name default
        ops_edit $ctl_aodh_conf service_credentials user_domain_name default
        ops_edit $ctl_aodh_conf service_credentials project_name service
        ops_edit $ctl_aodh_conf service_credentials username aodh
        ops_edit $ctl_aodh_conf service_credentials password $AODH_PASS
        ops_edit $ctl_aodh_conf service_credentials interface internalURL
        ops_edit $ctl_aodh_conf service_credentials region_name RegionOne
				
				ops_edit $ctl_aodh_conf api port 8042
				ops_edit $ctl_aodh_conf api host 0.0.0.0
				ops_edit $ctl_aodh_conf api paste_config api_paste.ini
				
				ops_edit $ctl_aodh_conf oslo_messaging_notifications driver messagingv2
				ops_edit $ctl_aodh_conf oslo_messaging_notifications topics notifications

}

function aodh_syncdb {
       aodh-dbsync --config-dir /etc/aodh/

}

function aodh_wsgi_config {
				wget -O /etc/httpd/conf.d/wsgi-aodh.conf https://raw.githubusercontent.com/tigerlinux/openstack-newton-installer-centos7/master/libs/aodh/wsgi-aodh.conf
				mkdir -p /var/www/cgi-bin/aodh				
				wget -O /var/www/cgi-bin/aodh/app.wsgi https://raw.githubusercontent.com/tigerlinux/openstack-newton-installer-centos7/master/libs/aodh/app.wsgi
				systemctl enable httpd
				systemctl stop memcached
				systemctl start memcached
				systemctl enable memcached
				systemctl stop httpd
				sleep 5
				systemctl start httpd
				sleep 5
}

function aodh_enable_restart {

        echocolor "Restart dich vu aodh"
        sleep 3
				systemctl enable \
				openstack-aodh-evaluator.service \
				openstack-aodh-notifier.service \
				openstack-aodh-listener.service

				systemctl start \
				openstack-aodh-evaluator.service \
				openstack-aodh-notifier.service \
				openstack-aodh-listener.service


}

############################
# Thuc thi cac functions
## Goi cac functions
############################
echocolor "Bat dau cai dat AODH"

echocolor "Tao DB AODH"
sleep 3
aodh_create_db

echocolor "Tao user va endpoint cho AODH"
sleep 3
aodh_user_endpoint

echocolor "Cai dat va cau hinh AODH"
sleep 3
aodh_install_config

echocolor "Dong bo DB cho AODH"
## Chi dong do neu AODH su dung SQL DATABASE de luu metric
sleep 3
aodh_syncdb

echocolor "Cau hinh WSGI cho AODH"
sleep 3
aodh_wsgi_config

echocolor "Restart dich vu AODH"
sleep 3
aodh_enable_restart
echocolor "Da cai dat xong AODH"
