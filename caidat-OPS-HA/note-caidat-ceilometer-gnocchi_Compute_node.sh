### Cai dat tren compute node 

yum install -y openstack-utils \
openstack-selinux \
openstack-ceilometer-compute \
python-ceilometerclient \
python-pecanyum install -y openstack-utils \
openstack-selinux \
openstack-ceilometer-compute \
python-ceilometerclient \
python-pecan


yum -y install python-pip
pip install requests-aws

## Lenh xem cau hinh /etc/ceilometer/ceilometer.conf
cat /etc/ceilometer/ceilometer.conf | egrep -v '^#|^$'

### Installing Ceilometer Packages"

# Keystone Authentication
cp /etc/ceilometer/ceilometer.conf  /etc/ceilometer/ceilometer.conf.orig

echo "#" >> /etc/ceilometer/ceilometer.conf

crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken admin_tenant_name service
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken admin_user ceilometer
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken admin_password 'Ec0net#!2017'
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_type password
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken username ceilometer
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken password 'Ec0net#!2017'
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken project_domain_name Default
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken user_domain_name Default

crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken project_name service

crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_uri http://192.168.20.33:5000
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_url http://192.168.20.33:35357
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken signing_dir '/var/lib/ceilometer/tmp-signing'
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken auth_version v3
crudini --set /etc/ceilometer/ceilometer.conf keystone_authtoken memcached_servers 192.168.20.33:11211

crudini --set /etc/ceilometer/ceilometer.conf service_credentials os_username ceilometer
crudini --set /etc/ceilometer/ceilometer.conf service_credentials os_password 'Ec0net#!2017'
crudini --set /etc/ceilometer/ceilometer.conf service_credentials os_tenant_name service
crudini --set /etc/ceilometer/ceilometer.conf service_credentials os_auth_url http://192.168.20.33:5000/v3
crudini --set /etc/ceilometer/ceilometer.conf service_credentials os_region_name RegionOne
crudini --set /etc/ceilometer/ceilometer.conf service_credentials os_endpoint_type internalURL
crudini --set /etc/ceilometer/ceilometer.conf service_credentials region_name RegionOne
crudini --set /etc/ceilometer/ceilometer.conf service_credentials interface internal
crudini --set /etc/ceilometer/ceilometer.conf service_credentials auth_type password

crudini --set /etc/ceilometer/ceilometer.conf service_credentials username ceilometer
crudini --set /etc/ceilometer/ceilometer.conf service_credentials password 'Ec0net#!2017'
crudini --set /etc/ceilometer/ceilometer.conf service_credentials auth_url http://192.168.20.33:5000/v3
crudini --set /etc/ceilometer/ceilometer.conf service_credentials project_domain_name Default
crudini --set /etc/ceilometer/ceilometer.conf service_credentials user_domain_name Default
crudini --set /etc/ceilometer/ceilometer.conf service_credentials project_name service
# End of Keystone Section

crudini --set /etc/ceilometer/ceilometer.conf DEFAULT metering_api_port 8777
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT auth_strategy keystone
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT log_dir /var/log/ceilometer
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT host `hostname`
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT pipeline_cfg_file pipeline.yaml
crudini --set /etc/ceilometer/ceilometer.conf collector workers 2
crudini --set /etc/ceilometer/ceilometer.conf notification workers 2
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT hypervisor_inspector libvirt

crudini --set /etc/ceilometer/ceilometer.conf DEFAULT nova_control_exchange nova
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT glance_control_exchange glance
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT neutron_control_exchange neutron
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT cinder_control_exchange cinder

crudini --set /etc/ceilometer/ceilometer.conf publisher telemetry_secret fe01a6ed3e04c4be1cd8
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT libvirt_type qemu

crudini --set /etc/ceilometer/ceilometer.conf DEFAULT debug false

crudini --set /etc/ceilometer/ceilometer.conf database metering_time_to_live 604800
crudini --set /etc/ceilometer/ceilometer.conf database time_to_live 604800
crudini --set /etc/ceilometer/ceilometer.conf database event_time_to_live 604800

crudini --set /etc/ceilometer/ceilometer.conf DEFAULT notification_topics notifications
 
# Hello Gnocchi !!
# crudini --set /etc/ceilometer/ceilometer.conf DEFAULT dispatcher gnocchi
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT meter_dispatchers gnocchi
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT event_dispatchers gnocchi
#

crudini --set /etc/ceilometer/ceilometer.conf oslo_messaging_rabbit rabbit_host 192.168.20.33
crudini --set /etc/ceilometer/ceilometer.conf oslo_messaging_rabbit rabbit_port 5672
crudini --set /etc/ceilometer/ceilometer.conf oslo_messaging_rabbit rabbit_userid openstack
crudini --set /etc/ceilometer/ceilometer.conf oslo_messaging_rabbit rabbit_password 'Ec0net#!2017'

crudini --set /etc/ceilometer/ceilometer.conf notification messaging_urls 'rabbit://openstack:Ec0net#!2017@192.168.20.33:5672/openstack'

crudini --set /etc/ceilometer/ceilometer.conf alarm evaluation_service ceilometer.alarm.service.SingletonAlarmService
crudini --set /etc/ceilometer/ceilometer.conf alarm partition_rpc_topic alarm_partition_coordination

crudini --set /etc/ceilometer/ceilometer.conf api port 8777
crudini --set /etc/ceilometer/ceilometer.conf api host 0.0.0.0

crudini --set /etc/ceilometer/ceilometer.conf DEFAULT heat_control_exchange heat
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT control_exchange ceilometer
crudini --set /etc/ceilometer/ceilometer.conf DEFAULT http_control_exchanges nova

sed -r -i 's/http_control_exchanges\ =\ nova/http_control_exchanges\ =\ nova\nhttp_control_exchanges\ =\ glance\nhttp_control_exchanges\ =\ cinder\nhttp_control_exchanges\ =\ neutron\n/' /etc/ceilometer/ceilometer.conf

crudini --set /etc/ceilometer/ceilometer.conf service_types neutron network
crudini --set /etc/ceilometer/ceilometer.conf service_types nova compute
crudini --set /etc/ceilometer/ceilometer.conf service_types swift object-store
crudini --set /etc/ceilometer/ceilometer.conf service_types glance image
crudini --del /etc/ceilometer/ceilometer.conf service_types kwapi
crudini --set /etc/ceilometer/ceilometer.conf service_types neutron_lbaas_version v2

crudini --set /etc/ceilometer/ceilometer.conf oslo_messaging_notifications topics notifications
crudini --set /etc/ceilometer/ceilometer.conf oslo_messaging_notifications driver messagingv2

crudini --set /etc/ceilometer/ceilometer.conf exchange_control heat_control_exchange heat
crudini --set /etc/ceilometer/ceilometer.conf exchange_control glance_control_exchange glance
crudini --set /etc/ceilometer/ceilometer.conf exchange_control keystone_control_exchange keystone
crudini --set /etc/ceilometer/ceilometer.conf exchange_control cinder_control_exchange cinder
crudini --set /etc/ceilometer/ceilometer.conf exchange_control sahara_control_exchange sahara
crudini --set /etc/ceilometer/ceilometer.conf exchange_control swift_control_exchange swift
crudini --set /etc/ceilometer/ceilometer.conf exchange_control magnum_control_exchange magnum
crudini --set /etc/ceilometer/ceilometer.conf exchange_control trove_control_exchange trove
crudini --set /etc/ceilometer/ceilometer.conf exchange_control nova_control_exchange nova
crudini --set /etc/ceilometer/ceilometer.conf exchange_control neutron_control_exchange neutron

crudini --set /etc/ceilometer/ceilometer.conf publisher_notifier telemetry_driver messagingv2
crudini --set /etc/ceilometer/ceilometer.conf publisher_notifier metering_topic metering
crudini --set /etc/ceilometer/ceilometer.conf publisher_notifier event_topic event

usermod -a -G libvirt,nova,kvm,qemu ceilometer > /dev/null 2>&1

mkdir -p /var/lib/ceilometer/tmp-signing
chown ceilometer.ceilometer /var/lib/ceilometer/tmp-signing
chmod 700 /var/lib/ceilometer/tmp-signing
chown ceilometer.ceilometer /var/log/ceilometer/*

mkdir -p /var/lib/ceilometer/tmp
chown ceilometer.ceilometer /var/lib/ceilometer/tmp

cp /etc/ceilometer/polling.yaml /etc/ceilometer/polling.yaml.orig 
wget -O /etc/ceilometer/polling.yaml https://raw.githubusercontent.com/tigerlinux/openstack-ocata-installer-centos7/master/libs/ceilometer/polling.yaml 
sed -r -i "s/METRICINTERVAL/60/g" /etc/ceilometer/polling.yaml

systemctl start openstack-ceilometer-compute
systemctl enable openstack-ceilometer-compute
systemctl disable openstack-ceilometer-polling > /dev/null 2>&1

