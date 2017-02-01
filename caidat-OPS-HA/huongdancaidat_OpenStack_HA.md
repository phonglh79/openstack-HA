# Hướng dẫn cài đặt OpenStack HA 

## Môi trường

- Ubuntu server 14.04  64 bit
- OpenStack Mitaka

## Thiết lập các host

- CTL1
- CTL2
- CTL3

### Cài đặt trên CTL1

#### Cấu hình network và host name

```sh
cat << EOF >> /etc/network/interfaces
#Assign IP for Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth0
iface eth0 inet static
address 10.10.10.51
netmask 255.255.255.0

# EXT NETWORK
auto eth1
iface eth1 inet static
address 172.16.69.51
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8
EOF
```

#### Cấu hình hostname

```sh
echo "controller1" > /etc/hostname
hostname -F /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1       localhost controller
10.10.10.50 	controller
10.10.10.51 	controller1
10.10.10.52 	controller2
10.10.10.53 	controller3
10.10.10.61 	compute1
10.10.10.62 	compute2
10.10.10.63 	compute3
EOF
```

#### Khai báo repos cài đặt OpenStack

```sh
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
```