

## C. Xử lý lỗi và các lệnh kiểm tra
### C.1. Xử lý tình huống các node galera không start được
- Log sau khi các 3 node bị reboot đồng thời: http://paste.openstack.org/raw/609728/
- Hoặc kiểm tra trạng thái của mariadb sẽ có kết quả: http://paste.openstack.org/raw/609729/
- Xử lý lỗi khi reboot đồng thời cụm database - galera (reboot mà ko chờ các node up).
  - Xem nội dung file `/var/lib/mysql/grastate.dat` trên tất cả các máy trong cluster, máy nào có dòng `safe_to_bootstrap:` với giá trị lớn hơn (thường là `1`) thì thực hiện lệnh
  
    ```sh
    galera_new_cluster
    ```
  - Sau khi xử lý xong sẽ có log ở `/var/log/messages` như sau: http://paste.openstack.org/raw/609730/
- Tiếp tục thực hiện restart mariadb trên các node còn lại để join cluster ` systemctl restart mariadb`
- Sau khi join lại xong, kiểm tra bằng lệnh sau để xem số node trong cluter đã ok hay chưa ()
  ```sh
  mysql -u root -p'Ec0net#!2017' -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
  ```
  - Kết quả lệnh trên như sau:
    ```sh
    [root@db3 ~]# mysql -u root -p'Ec0net#!2017' -e "SHOW STATUS LIKE 'wsrep_cluster_size'"
    Enter password:
    +--------------------+-------+
    | Variable_name      | Value |
    +--------------------+-------+
    | wsrep_cluster_size | 3     |
    +--------------------+-------+
    [root@db3 ~]#
    ```

### Khác
``
`
if [ "$1" == "controller" ]; then
      echo "$HOST_CTL" > $path_hostname
      hostname -F $path_hostname
  
  elif [ "$1" == "compute1" ]; then
      echo "$HOST_COM1" > $path_hostname
      hostname -F $path_hostname

  elif [ "$1" == "compute2" ]; then
      echo "$HOST_COM2" > $path_hostname
      hostname -F $path_hostname
  else
      echocolor "Cau hinh hostname that bai"
      echocolor "Cau hinh hostname that bai"
      exit 1
fi

echo "NAME=ens224" >> /etc/sysconfig/network-scripts/ifcfg-ens224
nmcli con reload
nmcli con show
curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/rabbitmq-bonding.sh


sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager

curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/rabbitmq1-ipadd.sh && bash rabbitmq1-ipadd.sh

- Đổi tên connection 
nmcli c modify "ens1" connection.id ens224

160 -> 192 -> 224 -> 256 -> 161 -> 193 -> 225 -> 257 -> 163 -> 194 -> 226 -> 258

ens160 -> ens192
ens224 -> ens256
ens161 -> ens193 
ens225 -> ens257
ens163 -> ens194
ens226 -> ens258

### 
Chay script bonding tren cac may LB

bash lb-bonding.sh lb1 10.10.20.31 10.10.10.31 192.168.20.31 192.168.40.31
bash lb-bonding.sh lb2 10.10.20.32 10.10.10.32 192.168.20.32 192.168.40.32


### Ghi chep ve add resource cho pacemaker
echo IP_VIP_API=10.10.20.30 >> lb-config.cfg 
echo IP_VIP_DB=10.10.10.30 >> lb-config.cfg 
echo IP_VIP_ADMIN=192.168.20.30 >> lb-config.cfg 

pcs resource create Virtual_IP_API ocf:heartbeat:IPaddr2 ip=10.10.20.30 cidr_netmask=32 op monitor interval=30s
pcs resource create Virtual_IP_MNGT ocf:heartbeat:IPaddr2 ip=192.168.20.30 cidr_netmask=32 op monitor interval=30s
pcs resource create Virtual_IP_DB ocf:heartbeat:IPaddr2 ip=10.10.10.30 cidr_netmask=32 op monitor interval=30s
pcs resource create Web_Cluster ocf:heartbeat:nginx configfile=/etc/nginx/nginx.conf status10url op monitor interval=5s

pcs constraint colocation add Web_Cluster with Virtual_IP_API INFINITY        
pcs constraint colocation add Web_Cluster with Virtual_IP_DB INFINITY     
pcs constraint colocation add Web_Cluster with Virtual_IP_MNGT INFINITY     

pcs constraint order Virtual_IP_API then Web_Cluster
pcs constraint order Virtual_IP_DB then Web_Cluster
pcs constraint order Virtual_IP_MNGT then Web_Cluster   


# pcs resource clone Web_Cluster globally-unique=true clone-max=2 clone-node-max=2
pcs constraint colocation add Web_Cluster with Virtual_IP_API INFINITY        
pcs constraint order Virtual_IP_API then Web_Cluster
pcs constraint order Virtual_IP_DB then Web_Cluster



#### Node keystone

 mysql+pymysql://keystone:KEYSTONE_DBPASS@controller/keystone

PASS_DATABASE_KEYSTONE='Ec0net@!20171
mysql+pymysql://keystone:Ec0net@!20171@10.10.10.30/keystone


crudini --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:'Ec0net@!2017'@10.10.10.30/keystone
crudini --set /etc/keystone/keystone.conf database connection mysql+pymysql://keystone:'Ec0net@!2017'@10.10.10.53/keystone

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'Ec0net@!2017' WITH GRANT OPTION ;FLUSH PRIVILEGES;

GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$PASS_DATABASE_ROOT' ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$PASS_DATABASE_ROOT';FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.20.61' IDENTIFIED BY '$PASS_DATABASE_ROOT' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.20.62' IDENTIFIED BY '$PASS_DATABASE_ROOT' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'192.168.20.63' IDENTIFIED BY '$PASS_DATABASE_ROOT' WITH GRANT OPTION ;FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' IDENTIFIED BY '$PASS_DATABASE_ROOT';FLUSH PRIVILEGES;


GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'Welcome123' WITH GRANT OPTION; FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Welcome123' WITH GRANT OPTION; FLUSH PRIVILEGES;


GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Ec0net@!2017' WITH GRANT OPTION; FLUSH PRIVILEGES;
FLUSH PRIVILEGES;"


PASS_DATABASE_ROOT='Ec0net@!2017'
PASS_DATABASE_KEYSTONE=PASS_DATABASE_ROOT
DB1_IP_NIC2=192.168.20.51
mysql -uroot -p$PASS_DATABASE_ROOT -h $DB1_IP_NIC2 -e "CREATE DATABASE keystone;

CREATE DATABASE keystone;
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY 'Ec0net#!2017';
GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY 'Ec0net#!2017';
FLUSH PRIVILEGES;

"

PASS_DATABASE_KEYSTONE='Ec0net@!2017'


slmgr /skms active.orientsoftware.asia
slmgr /ato

http://prntscr.com/f93zk6

connection = mysql+pymysql://keystone:Ec0net@!2017@10.10.10.30/keystone

su -s /bin/sh -c "keystone-manage db_sync" keystone

keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone
keystone-manage credential_setup --keystone-user keystone --keystone-group keystone


keystone-manage bootstrap --bootstrap-password Welcome123 \
  --bootstrap-admin-url http://10.10.20.61:35357/v3/ \
  --bootstrap-internal-url http://10.10.20.61:35357/v3/ \
  --bootstrap-public-url http://10.10.20.61:5000/v3/ \
  --bootstrap-region-id RegionOne



keystone-manage bootstrap --bootstrap-password Welcome123 \
  --bootstrap-admin-url http://10.10.20.6:35357/v3/ \
  --bootstrap-internal-url http://10.10.20.30:35357/v3/ \
  --bootstrap-public-url http://10.10.20.30:5000/v3/ \
  --bootstrap-region-id RegionOne
  
  
export OS_USERNAME=admin
export OS_PASSWORD=Ec0net#!2017
export OS_PROJECT_NAME=admin
export OS_USER_DOMAIN_NAME=Default
export OS_PROJECT_DOMAIN_NAME=Default
export OS_AUTH_URL=http://10.10.20.30:35357/v3
export OS_IDENTITY_API_VERSION=3

openstack project create --domain default --description "Service Project" service


systemctl enable httpd.service
systemctl start httpd.service
systemctl restart httpd.service


### Cai byobu
curl -O http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-9.noarch.rpm
rpm -ivh epel-release-7-9.noarch.rpm
sudo yum install byobu -y --enablerepo=epel-testing



### Chu y khi cai NEUTRON

# Goi tham khao 
yum -y install openstack-neutron 
yum -y install openstack-neutron-ml2
yum -y install ebtables
yum -y install openstack-neutron-linuxbridge 

## Cai tren cac CTL 
yum -y install openstack-neutron 
yum -y install openstack-neutron-ml2

## Dung tren ctl1
## Tao db cho neutron 
mysql -uroot -p'Ec0net#!2017' -h 192.168.20.51 -e "CREATE DATABASE neutron;
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY 'Ec0net#!2017';
GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY 'Ec0net#!2017';
FLUSH PRIVILEGES;"

## Tao user neutron va cac endpoint cho dich vu neutron 
openstack user create  neutron --domain default --password 'Ec0net#!2017'
openstack role add --project service --user neutron admin
openstack service create --name neutron --description "OpenStack Networking" network
openstack endpoint create --region RegionOne network public http://10.10.20.30:9696
openstack endpoint create --region RegionOne network internal  http://10.10.20.30:9696
openstack endpoint create --region RegionOne network admin  http://10.10.20.30:9696


###COMPUTENODE
##Dat IP cho COMPUTE1

hostnamectl set-hostname com1

echo "Setup IP  ens160"
nmcli c modify ens160 ipv4.addresses 10.10.20.71/24
nmcli c modify ens160 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

echo "Setup IP  ens192"
nmcli c modify ens192 ipv4.addresses 10.10.10.71/24
nmcli c modify ens192 ipv4.method manual
nmcli con mod ens192 connection.autoconnect yes


echo "Setup IP  ens224"
nmcli c modify ens224 ipv4.addresses 192.168.50.71/24
nmcli c modify ens224 ipv4.method manual
nmcli con mod ens224 connection.autoconnect yes

echo "Setup IP  ens256"
nmcli c modify ens256 ipv4.addresses 192.168.20.71/24
nmcli c modify ens256 ipv4.gateway 192.168.20.254
nmcli c modify ens256 ipv4.dns 8.8.8.8
nmcli c modify ens256 ipv4.method manual
nmcli con mod ens256 connection.autoconnect yes

echo "Setup IP  ens161"
nmcli c modify ens161 ipv4.addresses 172.16.20.71/24
nmcli c modify ens161 ipv4.method manual
nmcli con mod ens161 connection.autoconnect yes


echo "Setup IP  ens193"
nmcli c modify ens193 ipv4.addresses 10.10.10.71/24
nmcli c modify ens193 ipv4.method manual
nmcli con mod ens193 connection.autoconnect yes


sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config


##Dat IP cho COMPUTE2

hostnamectl set-hostname com2

echo "Setup IP  ens160"
nmcli c modify ens160 ipv4.addresses 10.10.20.72/24
nmcli c modify ens160 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

echo "Setup IP  ens192"
nmcli c modify ens192 ipv4.addresses 10.10.10.72/24
nmcli c modify ens192 ipv4.method manual
nmcli con mod ens192 connection.autoconnect yes


echo "Setup IP  ens224"
nmcli c modify ens224 ipv4.addresses 192.168.50.72/24
nmcli c modify ens224 ipv4.method manual
nmcli con mod ens224 connection.autoconnect yes

echo "Setup IP  ens256"
nmcli c modify ens256 ipv4.addresses 192.168.20.72/24
nmcli c modify ens256 ipv4.gateway 192.168.20.254
nmcli c modify ens256 ipv4.dns 8.8.8.8
nmcli c modify ens256 ipv4.method manual
nmcli con mod ens256 connection.autoconnect yes

echo "Setup IP  ens161"
nmcli c modify ens161 ipv4.addresses 172.16.20.72/24
nmcli c modify ens161 ipv4.method manual
nmcli con mod ens161 connection.autoconnect yes


echo "Setup IP  ens193"
nmcli c modify ens193 ipv4.addresses 10.10.10.72/24
nmcli c modify ens193 ipv4.method manual
nmcli con mod ens193 connection.autoconnect yes


sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config


### Tao nmay ao


# tao flavor
openstack flavor create --id 0 --vcpus 1 --ram 64 --disk 1 m1.nano

## Tao network

openstack network create  --share --external \
  --provider-physical-network provider \
  --provider-network-type flat provider
  
  
  
openstack subnet create --network provider \
  --allocation-pool start=192.168.40.200,end=192.168.40.250 \
  --dns-nameserver 8.8.8.8 --gateway 192.168.40.254 \
  --subnet-range 192.168.40.0/24 provider


neutron subnet-update --name provider --gateway 192.168.40.254 --dns-nameserver 8.8.8.8  \
--allocation-pool start=192.168.40.200,end=192.168.40.250 \
--subnet-range 192.168.40.0/24



## Tao fule 

openstack security group rule create --proto icmp default
openstack security group rule create --proto tcp --dst-port 22 default


openstack network list #lay ID cua network thay xuong duoi 


openstack server create --flavor m1.nano --image cirros \
  --nic net-id=a0d5f513-99fe-49da-80e8-076c21410de3 --security-group default \
  provider-instance
  
########

## CEPH1
hostnamectl set-hostname ceph1

echo "Setup IP  ens160"
nmcli c modify ens160 ipv4.addresses 192.168.20.91/24
nmcli c modify ens160 ipv4.gateway 192.168.20.254
nmcli c modify ens160 ipv4.dns 8.8.8.8
nmcli c modify ens160 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli c modify ens224 ipv4.addresses 10.10.0.91/24
nmcli c modify ens224 ipv4.method manual
nmcli con mod ens224 connection.autoconnect yes

echo "Setup IP  ens161"
nmcli c modify ens161 ipv4.addresses 172.16.10.91/24
nmcli c modify ens161 ipv4.method manual
nmcli con mod ens161 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6

## CEPH2
hostnamectl set-hostname ceph2

echo "Setup IP  ens160"
nmcli c modify ens160 ipv4.addresses 192.168.20.92/24
nmcli c modify ens160 ipv4.gateway 192.168.20.254
nmcli c modify ens160 ipv4.dns 8.8.8.8
nmcli c modify ens160 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli c modify ens224 ipv4.addresses 10.10.0.92/24
nmcli c modify ens224 ipv4.method manual
nmcli con mod ens224 connection.autoconnect yes

echo "Setup IP  ens161"
nmcli c modify ens161 ipv4.addresses 172.16.10.92/24
nmcli c modify ens161 ipv4.method manual
nmcli con mod ens161 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6

## CEPH3
hostnamectl set-hostname ceph3

echo "Setup IP  ens160"
nmcli c modify ens160 ipv4.addresses 192.168.20.93/24
nmcli c modify ens160 ipv4.gateway 192.168.20.254
nmcli c modify ens160 ipv4.dns 8.8.8.8
nmcli c modify ens160 ipv4.method manual
nmcli con mod ens160 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli c modify ens224 ipv4.addresses 10.10.0.93/24
nmcli c modify ens224 ipv4.method manual
nmcli con mod ens224 connection.autoconnect yes

echo "Setup IP  ens161"
nmcli c modify ens161 ipv4.addresses 172.16.10.93/24
nmcli c modify ens161 ipv4.method manual
nmcli con mod ens161 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6


############### GHI CHU KHI CAI CEILOMETER - GNOCCHI - AODH 
############################################################

Tao endpoint cho ceilomter

openstack user create ceilometer --domain default --password 'Ec0net#!2017'
openstack role add --project service --user ceilometer admin
openstack service create --name ceilometer --description "Telemetry" metering


openstack user create gnocchi --domain default --password 'Ec0net#!2017'
openstack service create --name gnocchi --description "Metric Service" metric

openstack endpoint create --region RegionOne metric public http://10.10.20.30:8041
openstack endpoint create --region RegionOne metric internal http://10.10.20.30:8041
openstack endpoint create --region RegionOne metric admin http://10.10.20.30:8041

yum install openstack-ceilometer-collector openstack-ceilometer-notification \
  openstack-ceilometer-central python-ceilometerclient
  
  
yum install -y openstack-ceilometer-api \
		openstack-ceilometer-central \
		openstack-ceilometer-collector \
		openstack-ceilometer-common \
		openstack-ceilometer-compute \
		openstack-ceilometer-polling \
		openstack-ceilometer-notification \
		python-ceilometerclient \
		python-ceilometer \
		python-ceilometerclient-doc \
		openstack-utils \
		openstack-selinux


