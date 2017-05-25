#!/bin/bash -ex 
##############################################################################
### Script cai dat cac goi bo tro cho CTL

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

function com_install_nova {
        yum install -y python-openstackclient openstack-selinux openstack-utils
        yum install -y openstack-nova-compute
}

function nova_config {
        com_nova_conf=/etc/nova/nova.conf
        cp $com_nova_conf $com_nova_conf.orig

        ops_edit $com_nova_conf DEFAULT enabled_apis osapi_compute,metadata
        ops_edit $com_nova_conf DEFAULT rpc_backend rabbit
        ops_edit $com_nova_conf DEFAULT auth_strategy keystone
        ops_edit $com_nova_conf DEFAULT my_ip $(ip addr show dev ens256 scope global | grep "inet " | sed -e 's#.*inet ##g' -e 's#/.*##g')
        ops_edit $com_nova_conf DEFAULT use_neutron true
        ops_edit $com_nova_conf DEFAULT firewall_driver nova.virt.firewall.NoopFirewallDriver

        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_hosts $MQ1_IP_NIC1:5672,$MQ2_IP_NIC1:5672,$MQ3_IP_NIC1:5672
        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_ha_queues true
        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_retry_interval 1
        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_retry_backoff 2
        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_max_retries 0
        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_durable_queues true
        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_userid openstack
        ops_edit $com_nova_conf oslo_messaging_rabbit rabbit_password $RABBIT_PASS

        ops_edit $com_nova_conf keystone_authtoken auth_uri http://$IP_VIP_API:5000
        ops_edit $com_nova_conf keystone_authtoken auth_url http://$IP_VIP_API:35357
        ops_edit $com_nova_conf keystone_authtoken memcached_servers $CTL1_IP_NIC1:11211,$CTL2_IP_NIC1:11211,$CTL3_IP_NIC1:11211
        ops_edit $com_nova_conf keystone_authtoken auth_type password
        ops_edit $com_nova_conf keystone_authtoken project_domain_name Default
        ops_edit $com_nova_conf keystone_authtoken user_domain_name Default
        ops_edit $com_nova_conf keystone_authtoken project_name service
        ops_edit $com_nova_conf keystone_authtoken username nova
        ops_edit $com_nova_conf keystone_authtoken password $NOVA_PASS

        ops_edit $com_nova_conf vnc enabled True
        ops_edit $com_nova_conf vnc vncserver_listen 0.0.0.0
        ops_edit $com_nova_conf vnc vncserver_proxyclient_address \$my_ip
        ops_edit $com_nova_conf vnc novncproxy_base_url http://$IP_VIP_ADMIN:6080/vnc_auto.html
        
        ops_edit $com_nova_conf glance api_servers http://$IP_VIP_API:9292
        
        ops_edit $com_nova_conf oslo_concurrency lock_path /var/lib/nova/tmp
        
        ops_edit $com_nova_conf libvirt virt_type  $(count=$(egrep -c '(vmx|svm)' /proc/cpuinfo); if [ $count -eq 0 ];then   echo "qemu"; else   echo "kvm"; fi)
 
}

function  com_restart_nova {
        systemctl enable libvirtd.service openstack-nova-compute.service
        systemctl start libvirtd.service openstack-nova-compute.service
        systemctl enable openstack-nova-compute.service
        systemctl start openstack-nova-compute.service
}

##############################################################################
# Thuc thi cac functions
## Goi cac functions
##############################################################################

echocolor "Install dich vu NOVA"
sleep 3
com_install_nova

echocolor "Restart dich vu NOVA"
sleep 3
com_restart_nova