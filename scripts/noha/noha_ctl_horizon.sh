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
##			ops_edit $bien_duong_dan_file [SECTION] [PARAMETER] [VALUAE]
## Vi du:
###			filekeystone=/etc/keystone/keystone.conf
###			ops_edit $filekeystone DEFAULT rpc_backend rabbit

# Ham de del mot dong trong file cau hinh
function ops_del {
    crudini --del $1 $2 $3
}


echocolor "Installing Dashboard package"
yum -y install openstack-dashboard


echocolor "Creating redirect page"

filehtml=/var/www/html/index.html
test -f $filehtml.orig || cp $filehtml $filehtml.orig
rm $filehtml
touch $filehtml
cat << EOF >> $filehtml
<html>
<head>
<META HTTP-EQUIV="Refresh" Content="0.5; URL=http://$CTL_EXT_IP/dashboard">
</head>
<body>
<center> <h1>Redirecting to OpenStack Dashboard</h1> </center>
</body>
</html>
EOF


echocolor "Config dashboard"
sleep 3
cp /etc/openstack-dashboard/local_settings \
    /etc/openstack-dashboard/local_settings.orig
    
filehorizon=/etc/openstack-dashboard/local_settings

# Allowing insert password in dashboard ( only apply in image )
sed -i "s/'can_set_password': False/'can_set_password': True/g" \
    $filehorizon

sed -i "s/_member_/user/g" $filehorizon
sed -i "s/127.0.0.1/$CTL1_IP_NIC1/g" $filehorizon
sed -i "s/http:\/\/\%s:5000\/v2.0/http:\/\/\%s:5000\/v3/g" \
    $filehorizon
    
sed -e 's/django.core.cache.backends.locmem.LocMemCache/django.core.cache.backends.memcached.MemcachedCache',\
         'LOCATION': '$CTL1_IP_NIC1:11211',/g' $filehorizon  


cat << EOF >> $filehorizon
OPENSTACK_API_VERSIONS = {
#    "data-processing": 1.1,
    "identity": 3,
    "volume": 2,
    "compute": 2,
}

SESSION_ENGINE = 'django.contrib.sessions.backends.cache'
EOF


sed -i "s/#OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'default'/\
OPENSTACK_KEYSTONE_DEFAULT_DOMAIN = 'default'/g" \
    $filehorizon

## /* Restarting apache2 and memcached
 systemctl restart httpd.service memcached.service
echocolor "Finish setting up Horizon"

chown root:apache local_settings

echocolor "LOGIN INFORMATION IN HORIZON"
echocolor "URL: http://$CTL_EXT_IP/dashboard"
echocolor "User: admin or demo"
echocolor "Password: $ADMIN_PASS"