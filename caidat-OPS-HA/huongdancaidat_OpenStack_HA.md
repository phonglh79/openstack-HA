# Hướng dẫn cài đặt OpenStack HA 

## Môi trường

- Ubuntu server 14.04  64 bit
- OpenStack Mitaka

## Thiết lập các host

- CTL1
- CTL2
- CTL3

### Thiết lập IP, hostname và repos

#### Cài đặt trên CTL1

- Sao lưu file cấu hình network

```sh
cp /etc/network/interfaces /etc/network/interfaces.orig
```

- Khai báo IP cho các NICs của node Controller1 

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

- Cấu hình hostname

```sh
echo "controller1" > /etc/hostname
hostname -F /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1       localhost controller1
10.10.10.50 	controller
10.10.10.51 	controller1
10.10.10.52 	controller2
10.10.10.53 	controller3
10.10.10.61 	compute1
10.10.10.62 	compute2
10.10.10.63 	compute3
EOF
```

-  Khai báo repos cài đặt OpenStack

```sh
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
```

- Khởi động lại node Controller1

```sh
init 6
```

#### Cài đặt trên CTL2

- Sao lưu file cấu hình network

```sh
cp /etc/network/interfaces /etc/network/interfaces.orig
```

- Khai báo IP cho các NICs của node Controller2

```sh
cat << EOF >> /etc/network/interfaces
#Assign IP for Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth0
iface eth0 inet static
address 10.10.10.52
netmask 255.255.255.0

# EXT NETWORK
auto eth1
iface eth1 inet static
address 172.16.69.52
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8
EOF
```

- Cấu hình hostname

```sh
echo "controller2" > /etc/hostname
hostname -F /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1       localhost controller2
10.10.10.50 	controller
10.10.10.51 	controller1
10.10.10.52 	controller2
10.10.10.53 	controller3
10.10.10.61 	compute1
10.10.10.62 	compute2
10.10.10.63 	compute3
EOF
```

-  Khai báo repos cài đặt OpenStack

```sh
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
```

- Khởi động lại node Controller2

```sh
init 6
```

#### Cài đặt trên CTL3

- Sao lưu file cấu hình network

```sh
cp /etc/network/interfaces /etc/network/interfaces.orig
```

- Khai báo IP cho các NICs của node Controller3

```sh
cat << EOF >> /etc/network/interfaces
#Assign IP for Controller node

# LOOPBACK NET
auto lo
iface lo inet loopback

# MGNT NETWORK
auto eth0
iface eth0 inet static
address 10.10.10.53
netmask 255.255.255.0

# EXT NETWORK
auto eth1
iface eth1 inet static
address 172.16.69.53
netmask 255.255.255.0
gateway 172.16.69.1
dns-nameservers 8.8.8.8
EOF
```

- Cấu hình hostname

```sh
echo "controller3" > /etc/hostname
hostname -F /etc/hostname

cat << EOF >> /etc/hosts
127.0.0.1       localhost controller3
10.10.10.50 	controller
10.10.10.51 	controller1
10.10.10.52 	controller2
10.10.10.53 	controller3
10.10.10.61 	compute1
10.10.10.62 	compute2
10.10.10.63 	compute3
EOF
```

-  Khai báo repos cài đặt OpenStack

```sh
apt-get install software-properties-common -y
add-apt-repository cloud-archive:mitaka -y
```

- Khởi động lại node Controller3

```sh
init 6
```

### Cài đặt Network Time Protocol (NTP)
#### Cài đặt NTP trên CTL1

- Tải gói `chrony`
```sh
apt-get -y install chrony
````

- Cấu hình NTP Server

```sh
cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.orig


sed -i 's/server 0.debian.pool.ntp.org offline minpoll 8/ \
server 1.vn.pool.ntp.org iburst \
server 0.asia.pool.ntp.org iburst \
server 3.asia.pool.ntp.org iburst/g' /etc/chrony/chrony.conf

sed -i 's/server 1.debian.pool.ntp.org offline minpoll 8/ \
# server 1.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 2.debian.pool.ntp.org offline minpoll 8/ \
# server 2.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 3.debian.pool.ntp.org offline minpoll 8/ \
# server 3.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf
```

- Khởi động lại NTP Server
```sh
/etc/init.d/chrony restart
 ```

#### Cài đặt NTP trên CTL2

- Tải gói NTP
```sh
apt-get -y install chrony
```

- Cấu hình NTP trên CTL2

```sh
cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.orig

sed -i "s/server 0.debian.pool.ntp.org offline minpoll 8/ \
server 10.10.10.51 iburst/g" /etc/chrony/chrony.conf

sed -i 's/server 1.debian.pool.ntp.org offline minpoll 8/ \
# server 1.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 2.debian.pool.ntp.org offline minpoll 8/ \
# server 2.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 3.debian.pool.ntp.org offline minpoll 8/ \
# server 3.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf
```

#### Cài đặt NTP trên CTL3

- Tải gói NTP
```sh
apt-get -y install chrony
```

- Cấu hình NTP trên CTL3

```sh
cp /etc/chrony/chrony.conf /etc/chrony/chrony.conf.orig

sed -i "s/server 0.debian.pool.ntp.org offline minpoll 8/ \
server 10.10.10.51 iburst/g" /etc/chrony/chrony.conf

sed -i 's/server 1.debian.pool.ntp.org offline minpoll 8/ \
# server 1.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 2.debian.pool.ntp.org offline minpoll 8/ \
# server 2.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf

sed -i 's/server 3.debian.pool.ntp.org offline minpoll 8/ \
# server 3.debian.pool.ntp.org offline minpoll 8/g' /etc/chrony/chrony.conf
```