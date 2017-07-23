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
- Chuyển sang quyền root
	```sh
	yum -y install git
	```
	
- Cài đặt git và script cài đặt.
	```sh
	yum -y install git
	git clone https://github.com/congto/openstack-HA.git

	mv openstack-HA/scripts/noha /root/

	cd noha
	chmod +x *.sh
	```

- Nếu muốn sửa các IP thì sử dụng VI hoặc VIM để sửa, cần lưu ý tên NICs và địa chỉ IP cần phải tương ứng (trong này này tên NICs là ens160, ens192, ens224, ens256)

- Trong toàn bộ quá trình chạy script, chỉ cần thực hiện trên node CTL1, script sẽ tự động cài đặt các node còn lại. Do vậy cần phải ping được từ node CTL1 tới COM1 và COM2 để đảm bảo CTL1 có thể tạo ssh keygen cho COM1 và COM2.

	```sh
	ping 192.168.20.34 
	ping 192.168.20.35
	```

-  Nếu cần thiết thì cài ứng dụng `byobu` để khi các phiên ssh bị mất kết nối thì có thể sử dụng lại (để sử đụng lại thì cần ssh vào và gõ lại lệnh `byobu`)

	```sh
	sudo yum install epel-release -y
	sudo yum install byobu -y --enablerepo=epel-testing
	```

- Gõ lệnh byobu

	```sh
	byobu
	```

#### Thực thi script `noha_ctl_prepare.sh`

- Lưu ý, lúc này cửa sổ nhắc lệnh đang ở thư mục `/root/noha/` của node CTL1

- Thực thi script  `noha_ctl_prepare.sh`

	```sh
	bash noha_ctl_prepare.sh
	```

- Trong quá trình chạy script, cần nhập password cho tài khoản root của máy COM1 và COM2


#### Thực thi script `noha_ctl_install_db_rabbitmq.sh` để cài đặt DB và các gói bổ trợ.
- Sau khi node CTL khởi động lại, đăng nhập bằng quyền root và thực thi các lệnh dưới.

	```sh
	cd /root/noha/

	bash noha_ctl_install_db_rabbitmq.sh
	```

#### Thực thi script `noha_ctl_keystone.sh` để cài đặt `Keystone`.

- Thực thi script bằng lệnh dưới.
	```sh
	bash noha_ctl_keystone.sh
	```

- Sau khi cài đặt xong keystone, script sẽ tạo ra 2 file source `admin-openrc` và `demo-openrc` nằm ở thư mục root. Các file này chứa biến môi trường để làm việc với OpenStack. Thực hiện lệnh dưới để có thể tương tác với OpenStack bằng CLI.

	```sh
	source /root/admin-openrc
	```

- Kiểm tra lại xem đã thao tác được với OpenStack bằng CLI hay chưa bằng lệnh

```sh
openstack token issue
```

	- Kết quả là:
	
		```sh
		+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
		| Field      | Value                                                                                                                                                                                   |
		+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
		| expires    | 2017-07-18 16:35:00+00:00                                                                                                                                                               |
		| id         | gAAAAABZbiqkN6mxVSttOCHdbPgCFAHmdlvdfHUpf2MrV_1nwq_ZrXGNJEdT-e7HInzxF8puHMG0-dnwe-NqRMvMDn_-lpYTX7m5G-oIpw4nWX0B9orECIYN4DXfUa07tg6pyo8-Zi7yte9uxqH54S1LYgdlk-GyX9130JESn3I_cw63b_9Rz-s |
		| project_id | 023aabfb532f4974a07923f1b48f1e2a                                                                                                                                                        |
		| user_id    | 3b79c537783f409e9cc28d6cef6ad393                                                                                                                                                        |
		+------------+-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
		[root@ctl1 noha]#
		```

#### Thực thi script `noha_ctl_glance.sh` để cài đặt `Glance`.

- Thực thi script dưới để cài đặt Glance.

	```sh
	bash noha_ctl_glance.sh
	```
	
#### Thực thi script `noha_ctl_nova.sh.sh` để cài đặt `Nova`.

- Thực thi script dưới để cài đặt Nova.

	```sh
	bash noha_ctl_nova.sh
	```
	
- Sau khi script thực thi xong, kiểm tra xem nova đã cài đặt thành công trên Controller bằng lệnh dưới.
	```sh
	openstack compute service list
	```

  - Kết quả như sau là đã hoàn tất việc cài nova trên controller
	
		```sh
		+----+------------------+------+----------+---------+-------+----------------------------+
		| ID | Binary           | Host | Zone     | Status  | State | Updated At                 |
		+----+------------------+------+----------+---------+-------+----------------------------+
		|  3 | nova-consoleauth | ctl1 | internal | enabled | up    | 2017-07-18T15:46:34.000000 |
		|  4 | nova-scheduler   | ctl1 | internal | enabled | up    | 2017-07-18T15:46:37.000000 |
		|  5 | nova-conductor   | ctl1 | internal | enabled | up    | 2017-07-18T15:46:31.000000 |
		+----+------------------+------+----------+---------+-------+----------------------------+
		```

#### Thực thi script `noha_ctl_neutron.sh` để cài đặt `Neutron`.

- Thực thi script dưới để cài đặt Neutron.

	```sh
	bash noha_ctl_neutron.sh
	```
	
#### Thực thi script `noha_ctl_cinder.sh` để cài đặt `Cinder`.

- Thực thi script dưới để cài đặt Cinder. 
- Lưu ý: Máy CTL có 02 ổ cứng, ổ thứ nhất để cài OS, ổ thứ 2 (sdb hoặc vdb) dùng để tạo các LVM để Cinder sử dụng sau này.

	```sh
	bash noha_ctl_cinder.sh
	```
	
### Thực hiện cài đặt trên Compute1 và Compute2 (cài Nova và Neutron)

#### Cài đặt Nova và neutron trên Compute1 và Compute2

- Login vào máy Compute1, kiểm tra xem đã có file `config.cfg` trong thư mục root hay chưa. File này được copy khi thực hiện script đầu tiên ở trên node Controller. Nếu chưa có thì copy từ Controller sang. Nếu có rồi thì thực hiện bước dưới.
- Tải script cài đặt nova và neutron cho Compute1

	```sh
	curl -O https://raw.githubusercontent.com/congto/openstack-HA/master/scripts/noha/noha_com_install.sh
	
	bash noha_com_install.sh
	```

- Lưu ý: bước này thực hiện trên cả 02 Compute1 và Compute2

### Kiểm tra lại xem Nova và Neutron 

- Để kiểm tra Nova và Neutron đã được cài thành công trên 2 node Compute1 và Compute2 hay chưa bằng các lệnh dưới.

- Đứng trên Controller thực hiện lệnh kiểm tra các agent của neutron. 
	```sh
	[root@ctl1 ~]# openstack network agent list
	```

	- Kết quả nhu dưới
		```sh

		+--------------------------------------+--------------------+------+-------------------+-------+-------+---------------------------+
		| ID                                   | Agent Type         | Host | Availability Zone | Alive | State | Binary                    |
		+--------------------------------------+--------------------+------+-------------------+-------+-------+---------------------------+
		| 1dbe7df1-feee-4f28-91ac-a19ed2ca0491 | Metadata agent     | com2 | None              | True  | UP    | neutron-metadata-agent    |
		| 560459e5-15ed-4cbf-a360-022a764fc642 | Metadata agent     | com1 | None              | True  | UP    | neutron-metadata-agent    |
		| 9d7f31c9-b5a8-4d36-bafb-940b8cacf2fa | Linux bridge agent | com2 | None              | True  | UP    | neutron-linuxbridge-agent |
		| a3402985-7b73-4090-b039-54186aa6642e | DHCP agent         | com1 | nova              | True  | UP    | neutron-dhcp-agent        |
		| d4f3b500-7865-40d7-ad6f-cf7c05284604 | DHCP agent         | com2 | nova              | True  | UP    | neutron-dhcp-agent        |
		| e26be4a6-ffa1-448f-9c1d-7b13de6ebea3 | Linux bridge agent | com1 | None              | True  | UP    | neutron-linuxbridge-agent |
		+--------------------------------------+--------------------+------+-------------------+-------+-------+---------------------------+
		```

- Đứng trên Controller thực hiện lệnh kiểm tra service của nova 
	```sh
	openstack compute service list
	```

	- Kết quả là: 
		```
		+----+------------------+------+----------+---------+-------+----------------------------+
		| ID | Binary           | Host | Zone     | Status  | State | Updated At                 |
		+----+------------------+------+----------+---------+-------+----------------------------+
		|  3 | nova-consoleauth | ctl1 | internal | enabled | up    | 2017-07-18T16:31:09.000000 |
		|  4 | nova-scheduler   | ctl1 | internal | enabled | up    | 2017-07-18T16:31:09.000000 |
		|  5 | nova-conductor   | ctl1 | internal | enabled | up    | 2017-07-18T16:31:08.000000 |
		|  6 | nova-compute     | com1 | nova     | enabled | up    | 2017-07-18T16:31:04.000000 |
		|  7 | nova-compute     | com2 | nova     | enabled | up    | 2017-07-18T16:31:14.000000 |
		+----+------------------+------+----------+---------+-------+----------------------------+
		```

### Tạo network  và các máy ảo để kiểm chứng. 

#### Tạo provider network