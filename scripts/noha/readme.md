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

- Lưu ý, lúc này cửa sổ nhắc lệnh đang ở thư mục `/root/noha/`

- Thực thi script  `noha_ctl_prepare.sh`

```sh
bash noha_ctl_prepare.sh
```

- Trong quá trình chạy script, cần nhập password cho tài khoản root của máy COM1 và COM2








	