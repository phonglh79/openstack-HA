# Hướng dẫn thực hiện

### Môi trường lab
- OS: Centos Minimal 7.3 - 64 bit

### Mô hình

### IP Planning


## 1. Cài đặt trên các node LB

### 1.1. Thực hiện script cấu hình bonding 
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

### 1.2. Thực hiện script cài đặt pacemaker, corosync, cấu hình cluster cho 2 máy LB.

- Đứng trên máy chủ LB1, thực hiện script sau. Kết thúc script thì cả 2 node sẽ được cài đặt pacemaker, corosync và cấu hình cluster. 
  ```sh
  curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/lb-install.sh
  bash lb-install.sh
  ```
  
  

