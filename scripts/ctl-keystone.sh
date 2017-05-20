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

function create_keystone_db {
mysql -uroot -p$PASS_DATABASE_ROOT -h $DB1_IP_NIC2 -e "CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '"$PASS_DATABASE_KEYSTONE"';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '"$PASS_DATABASE_KEYSTONE"';
FLUSH PRIVILEGES;"
}

function keystone_install {
        yum -y install openstack-keystone httpd mod_wsgi
        cp /etc/keystone/keystone.conf /etc/keystone/keystone.conf.orig
        
}

function keystone_config {
          /etc/keystone/keystone.conf=keystone_conf
          ops_edit $keystone_conf database connection mysql+pymysql://keystone:$PASS_DATABASE_KEYSTONE@$virtual_ip/keystone
          ops_edit $keystone_conf token provider fernet         
}

function keystone_create {
          su -s /bin/sh -c "keystone-manage db_sync" keystone
          keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
          keystone-manage credential_setup --keystone-user keystone --keystone-group keystone
          scp 
          keystone-manage bootstrap --bootstrap-password $ADMIN_PASS \
          --bootstrap-admin-url http://$IP_VIP_API:35357/v3/ \
          --bootstrap-internal-url http://$IP_VIP_API:5000/v3/ \
          --bootstrap-public-url http://$IP_VIP_API:5000/v3/ \
          --bootstrap-region-id RegionOne
}

function keystone_install_http {
          echo "ServerName `hostname`" >> /etc/httpd/conf/httpd.conf
          ln -s /usr/share/keystone/wsgi-keystone.conf /etc/httpd/conf.d/
          systemctl enable httpd.service
          systemctl start httpd.service
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

echocolor "Cau hinh keystone"
sleep 3
