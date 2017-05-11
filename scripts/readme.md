# Hướng dẫn thực hiện

### Môi trường lab
- OS: Centos Minimal 7.3 - 64 bit

### Mô hình

### IP Planning


## 1. Cài đặt trên các node LoadBalancer (Pacemaker, Corosync, Nginx)

### 1.1. Thực hiện script cấu hình bonding cho các node LB
- Đứng trên máy chủ LB1, tải và thực hiện script để cấu hình bonding
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/lb-bonding.sh
  bash lb-bonding.sh lb1 10.10.20.31 10.10.10.31 192.168.20.31 192.168.40.31
  ```

- Đứng trên máy chủ LB2, tải và thực hiện script để cấu hình bonding
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/lb-bonding.sh
  bash lb-bonding.sh lb2 10.10.20.32 10.10.10.32 192.168.20.32 192.168.40.32
  ```

### 1.2. Thực hiện script cài đặt pacemaker, corosync, cấu hình cluster

- Đứng trên máy chủ LB1, thực hiện script sau. Kết thúc script thì cả 2 node sẽ được cài đặt pacemaker, corosync và cấu hình cluster. 
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/lb-install.sh
  bash lb-install.sh
  ```
  
- Sau khi cấu hình cluster xong, thực hiện add resources cho pacemaker
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/lb-add-resources.sh
  bash lb-add-resources.sh
  ```

## 2. Cài đặt RABBITMQ Cluster

### 2.1. Thực hiện script cấu hình bonding cho các RABBITMQ
- Đăng nhập vào máy RABBITMQ1 và thực hiện các lệnh sau.
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/rabbitmq-bonding.sh
  bash rabbitmq-bonding.sh mq1 10.10.10.41 192.168.20.41
  ```
  
- Đăng nhập vào máy RABBITMQ2 và thực hiện các lệnh sau.
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/rabbitmq-bonding.sh
  bash rabbitmq-bonding.sh mq2 10.10.10.42 192.168.20.42
  ```

- Đăng nhập vào máy RABBITMQ3 và thực hiện các lệnh sau.
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/rabbitmq-bonding.sh
  bash rabbitmq-bonding.sh mq3 10.10.10.43 192.168.20.43
  ```
  
### 2.2. Thực hiện cài đặt cluster cho rabbitmq
- Đứng trên node MQ1 và thực hiện script sau, trong quá trình cài cần nhập mật khẩu root của 03 máy rabbitmq
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/rabbitmq-install.sh
  bash rabbitmq-install.sh
  ````
  
  
## 3. Cài đặt MariaDB Cluster

### 3.1. Thực hiện script cấu hình bonding cho các MariaDB
- Đăng nhập vào máy MariaDB1 và thực hiện các lệnh sau.
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/db-bonding.sh
  bash db-bonding.sh db1 10.10.10.51 192.168.20.51
  ```
  
- Đăng nhập vào máy MariaDB2 và thực hiện các lệnh sau.
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/db-bonding.sh
  bash db-bonding.sh db2 10.10.10.52 192.168.20.52
  ```

- Đăng nhập vào máy MariaDB3 và thực hiện các lệnh sau.
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/db-bonding.sh
  bash db-bonding.sh db3 10.10.10.53 192.168.20.53
  ```
  
## 4. Cài đặt trên các node Controller

### 4.1. Thực hiện script cấu hình bonding cho các node CONTROLLER
- Đứng trên máy chủ CTL1, tải và thực hiện script để cấu hình bonding
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/ctl-bonding.sh
  bash ctl-bonding.sh ctl1 10.10.20.61 10.10.10.61 192.168.20.61 10.10.0.61
  ```

- Đứng trên máy chủ CTL2, tải và thực hiện script để cấu hình bonding
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/ctl-bonding.sh
  bash ctl-bonding.sh ctl2 10.10.20.62 10.10.10.62 192.168.20.62 10.10.0.62
  ```

- Đứng trên máy chủ CTL3, tải và thực hiện script để cấu hình bonding
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/ctl-bonding.sh
  bash ctl-bonding.sh ctl3 10.10.20.63 10.10.10.63 192.168.20.63 10.10.0.63
  ```