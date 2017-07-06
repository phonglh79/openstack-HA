# Ghi chep ve openstack newton va midonet

## Setup cho Midonet
### Dat IP cho node gateway1

hostnamectl set-hostname gateway1

echo "Setup IP  ens160"
nmcli con modify ens160 ipv4.addresses 192.168.20.55/24
nmcli con modify ens160 ipv4.method manual
nmcli con modify ens160 connection.autoconnect yes

echo "Setup IP  ens192"
nmcli con modify ens192 ipv4.addresses 172.16.20.55/24
nmcli con modify ens192 ipv4.method manual
nmcli con modify ens192 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli con modify ens224 ipv4.addresses 192.168.40.55/24
nmcli con modify ens224 ipv4.gateway 192.168.40.254
nmcli con modify ens224 ipv4.dns 8.8.8.8
nmcli con modify ens224 ipv4.method manual
nmcli con modify ens224 connection.autoconnect yes

echo "Setup IP  ens256"
nmcli con modify ens256 ipv4.addresses 192.168.50.55/24
nmcli con modify ens256 ipv4.method manual
nmcli con modify ens256 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6

### Dat IP cho node gateway2

hostnamectl set-hostname gateway2

echo "Setup IP  ens160"
nmcli con modify ens160 ipv4.addresses 192.168.20.56/24
nmcli con modify ens160 ipv4.method manual
nmcli con modify ens160 connection.autoconnect yes

echo "Setup IP  ens192"
nmcli con modify ens192 ipv4.addresses 172.16.20.56/24
nmcli con modify ens192 ipv4.method manual
nmcli con modify ens192 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli con modify ens224 ipv4.addresses 192.168.40.56/24
nmcli con modify ens224 ipv4.gateway 192.168.40.254
nmcli con modify ens224 ipv4.dns 8.8.8.8
nmcli con modify ens224 ipv4.method manual
nmcli con modify ens224 connection.autoconnect yes

echo "Setup IP  ens256"
nmcli con modify ens256 ipv4.addresses 192.168.40.56/24
snmcli con modify ens256 ipv4.method manual
nmcli con modify ens256 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6


##########################
### Dat IP cho node nsdb1
##########################


hostnamectl set-hostname nsdb1

echo "Setup IP  ens160"
nmcli con modify ens160 ipv4.addresses 192.168.20.57/24
nmcli con modify ens160 ipv4.gateway 192.168.20.254
nmcli con modify ens160 ipv4.dns 8.8.8.8
nmcli con modify ens160 ipv4.method manual
nmcli con modify ens160 connection.autoconnect yes

echo "Setup IP  ens192"
nmcli con modify ens192 ipv4.addresses 172.16.20.57/24
nmcli con modify ens192 ipv4.method manual
nmcli con modify ens192 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli con modify ens224 ipv4.addresses 192.168.40.57/24
nmcli con modify ens224 ipv4.method manual
nmcli con modify ens224 connection.autoconnect yes

echo "Setup IP  ens256"
nmcli con modify ens256 ipv4.addresses 192.168.50.57/24
nmcli con modify ens256 ipv4.method manual
nmcli con modify ens256 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6


##########################
### Dat IP cho node nsdb2
##########################

hostnamectl set-hostname nsdb2

echo "Setup IP  ens160"
nmcli con modify ens160 ipv4.addresses 192.168.20.58/24
nmcli con modify ens160 ipv4.gateway 192.168.20.254
nmcli con modify ens160 ipv4.dns 8.8.8.8
nmcli con modify ens160 ipv4.method manual
nmcli con modify ens160 connection.autoconnect yes

echo "Setup IP  ens192"
nmcli con modify ens192 ipv4.addresses 172.16.20.58/24
nmcli con modify ens192 ipv4.method manual
nmcli con modify ens192 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli con modify ens224 ipv4.addresses 192.168.40.58/24
nmcli con modify ens224 ipv4.method manual
nmcli con modify ens224 connection.autoconnect yes

echo "Setup IP  ens256"
nmcli con modify ens256 ipv4.addresses 192.168.50.58/24
nmcli con modify ens256 ipv4.method manual
nmcli con modify ens256 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6

##########################
### Dat IP cho node nsdb3
##########################

hostnamectl set-hostname nsdb3

echo "Setup IP  ens160"
nmcli con modify ens160 ipv4.addresses 192.168.20.59/24
nmcli con modify ens160 ipv4.gateway 192.168.20.254
nmcli con modify ens160 ipv4.dns 8.8.8.8
nmcli con modify ens160 ipv4.method manual
nmcli con modify ens160 connection.autoconnect yes

echo "Setup IP  ens192"
nmcli con modify ens192 ipv4.addresses 172.16.20.59/24
nmcli con modify ens192 ipv4.method manual
nmcli con modify ens192 connection.autoconnect yes

echo "Setup IP  ens224"
nmcli con modify ens224 ipv4.addresses 192.168.40.59/24
nmcli con modify ens224 ipv4.method manual
nmcli con modify ens224 connection.autoconnect yes

echo "Setup IP  ens256"
nmcli con modify ens256 ipv4.addresses 192.168.50.59/24
nmcli con modify ens256 ipv4.method manual
nmcli con modify ens256 connection.autoconnect yes

sudo systemctl disable firewalld
sudo systemctl stop firewalld
sudo systemctl disable NetworkManager
sudo systemctl stop NetworkManager
sudo systemctl enable network
sudo systemctl start network

sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/sysconfig/selinux
sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config

init 6

##############################
Khai bao tren tat ca cac node
##############################

echo "192.168.20.55 gateway1" >> /etc/hosts
echo "192.168.20.56 gateway2" >> /etc/hosts
echo "192.168.20.57 nsdb1" >> /etc/hosts
echo "192.168.20.58 nsdb2" >> /etc/hosts
echo "192.168.20.59 nsdb3" >> /etc/hosts

echo "proxy=http://123.30.178.220:3142" >> /etc/yum.conf 
yum -y update

yum -y install https://rdoproject.org/repos/openstack-newton/rdo-release-newton.rpm

# - Khai bao repos cho Cassandra

echo '# DataStax (Apache Cassandra)
[datastax]
name = DataStax Repo for Apache Cassandra
baseurl = http://rpm.datastax.com/community
enabled = 1
gpgcheck = 1
gpgkey = https://rpm.datastax.com/rpm/repo_key' >> /etc/yum.repos.d/datastax.repo

# - Khai bao repos cho Midonet 

echo '[midonet]
name=MidoNet
baseurl=http://builds.midonet.org/midonet-5.4/stable/el7/
enabled=1
gpgcheck=1
gpgkey=https://builds.midonet.org/midorepo.key

[midonet-openstack-integration]
name=MidoNet OpenStack Integration
baseurl=http://builds.midonet.org/openstack-newton/stable/el7/
enabled=1
gpgcheck=1
gpgkey=https://builds.midonet.org/midorepo.key

[midonet-misc]
name=MidoNet 3rd Party Tools and Libraries
baseurl=http://builds.midonet.org/misc/stable/el7/
enabled=1
gpgcheck=1
gpgkey=https://builds.midonet.org/midorepo.key' >> /etc/yum.repos.d/midonet.repo

# - Upgrade sau khi khai bao repos va reboot cac may chu

yum clean all
yum -y upgrade

init 6

###############################
# Cai dat tren cac node NSDB
###############################

# - Cai dat zookeeper
yum -y install java-1.8.0-openjdk-headless
yum -y install zookeeper zkdump nmap-ncat

- Sua file cau hinh /etc/zookeeper/zoo.cfg


echo "server.1=nsdb1:2888:3888" >> /etc/zookeeper/zoo.cfg
echo "server.2=nsdb2:2888:3888" >> /etc/zookeeper/zoo.cfg
echo "server.3=nsdb3:2888:3888" >> /etc/zookeeper/zoo.cfg
echo "autopurge.snapRetainCount=10" >> /etc/zookeeper/zoo.cfg
echo "autopurge.purgeInterval =12" >> /etc/zookeeper/zoo.cfg

- Tao thu muc chua data cho zookeeper
# (trong tai lieu can buoc nay, nhung khi cai thay da phan quyen va co thu muc roi)

mkdir /var/lib/zookeeper/data
chown zookeeper:zookeeper /var/lib/zookeeper/data


- Dung tren NSDB1 thuc hien lenh duoi de khai bao ID cho NSDB1
echo 1 > /var/lib/zookeeper/myid

- Dung tren NSDB2 thuc hien lenh duoi de khai bao ID cho NSDB1

echo 2 > /var/lib/zookeeper/myid


- Dung tren NSDB3 thuc hien lenh duoi de khai bao ID cho NSDB1

echo 3 > /var/lib/zookeeper/myid

- Tao java link tren ca 3 node

mkdir -p /usr/java/default/bin/
ln -s /usr/lib/jvm/jre-1.8.0-openjdk/bin/java /usr/java/default/bin/java

- Start Zookeeper tren ca 3 node 

systemctl enable zookeeper.service
systemctl start zookeeper.service
systemctl status zookeeper.service

- NEU CAN THIET thi khoi dong lai 03 node 

init 6 

- Dung tren ca 3 node NSDB kiem tra zookeeper da hoat dong hay chua bang lenh 

echo ruok | nc 127.0.0.1 2181

- Ket qua tra ve nhu sau la ok 

http://prntscr.com/frty8y
http://prntscr.com/frtxwq
http://prntscr.com/frty50

- Dung tu mot node (vi du NSDB1) kiem tra hoat dong cua zookeeper toi cac node khac bang lenh:

echo stat | nc nsdb2 2181
echo stat | nc nsdb3 2181

- Ket qua nhu sau la ok: http://prntscr.com/fs7fs9

##############################
# - Cai dat cac goi Cassandra
##############################

yum -y install java-1.8.0-openjdk-headless
yum -y install dsc22

- Cau hinh file /etc/cassandra/conf/cassandra.yaml tren ca 3 node 

- Sua dong cluster_name nhu sau

cluster_name: 'midonet'

- Sua dong 

seeds: "nsdb1,nsdb2,nsdb3"

- Ket qua sua 2 dong tren nhu sau: 

http://prntscr.com/fruur2

- Hoac dung cach duoi 

sed -i 's/seeds: "127.0.0.1"/seeds: "nsdb1,nsdb2,nsdb3"/g' /etc/cassandra/conf/cassandra.yaml
sed -i "s/cluster_name: 'Test Cluster'/cluster_name: 'midonet'/g" /etc/cassandra/conf/cassandra.yaml

- Cau hinh tham so listen_address va  rpc_address tren node NSBD1

sed -i 's/listen_address: localhost/listen_address: nsdb1/g' /etc/cassandra/conf/cassandra.yaml
sed -i 's/rpc_address: localhost/rpc_address: nsdb1/g' /etc/cassandra/conf/cassandra.yaml


- Cau hinh tham so listen_address va  rpc_address tren node NSBD2

sed -i 's/listen_address: localhost/listen_address: nsdb2/g' /etc/cassandra/conf/cassandra.yaml
sed -i 's/rpc_address: localhost/rpc_address: nsdb2/g' /etc/cassandra/conf/cassandra.yaml

- Cau hinh tham so listen_address va  rpc_address tren node NSBD3

sed -i 's/listen_address: localhost/listen_address: nsdb3/g' /etc/cassandra/conf/cassandra.yaml
sed -i 's/rpc_address: localhost/rpc_address: nsdb3/g' /etc/cassandra/conf/cassandra.yaml


 - Tren ca 3 node nsdb1, nsdb2, nsdb3 mo file /etc/init.d/cassandra va them 2 dong duoi 
mkdir -p /var/run/cassandra 
chown cassandra:cassandra /var/run/cassandra 

vao doan nhu sau: http://prntscr.com/fs7iet


- Kích hoạt cassandra và khởi động

systemctl enable cassandra.service
systemctl start cassandra.service

- Kiểm tra hoạt động của cassandra trên từng node bằng lệnh

nodetool --host 127.0.0.1 status

- Kết quả như bên dưới là ok: 
http://prntscr.com/fs7mpl
http://prntscr.com/fs7mro
http://prntscr.com/fs7mvu











