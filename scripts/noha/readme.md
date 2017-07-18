#### Hướng dẫn thực thi script cài đặt OpenStack Newton

### Môi trường

### MÔ HÌNH

![noha_openstack_topology.png](/images/noha_openstack_topology.png)

### IP PLANNING

![noha_ip_planning.png](/images/noha_ip_planning.png)



## Các bước thực hiện

### Đặt IP theo IP Planning cho từng node.
- Trên Controller thực hiện
	```sh
	curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/noha/setup_ip.sh
	bash setup_ip.sh ctl1 192.168.20.33 10.10.0.33 172.16.20.33 192.168.40.33
	```

- Trên Compute1 thực hiện
	```sh
	curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/noha/setup_ip.sh
	bash setup_ip.sh com1 192.168.20.34 10.10.0.34 172.16.20.34 192.168.40.34
	```

- Trên Compute2 thực hiện

	```sh
	curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/noha/setup_ip.sh
	bash setup_ip.sh com1 192.168.20.35 10.10.0.35 172.16.20.35 192.168.40.35
	```
	
### Thực hiện script cài đặt OpenStack

- Đứng trên node CTL1 và thực hiện các bước dưới.
- Đăng nhập với quyền root , cài đặt git và script cài đặt.

```sh
yum -y install git
git clone https://github.com/congto/openstack-HA.git

```









	