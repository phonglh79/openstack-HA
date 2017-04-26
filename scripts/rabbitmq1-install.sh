#!/bin/bash -ex
### Script cai dat rabbitmq tren mq1

echo "Cai dat rabbitmq"
sleep 5

yum install -y centos-release-openstack-newton
yum upgrade

yum install -y rabbitmq-server

systemctl enable rabbitmq-server.service
systemctl start rabbitmq-server.service

rabbitmqctl add_user openstack Welcome123
rabbitmqctl set_permissions openstack ".*" ".*" ".*"

# scp /var/lib/rabbitmq/.erlang.cookie root@mq2:/var/lib/rabbitmq/.erlang.cookie
# scp /var/lib/rabbitmq/.erlang.cookie root@mq3:/var/lib/rabbitmq/.erlang.cookie

rabbitmqctl set_policy ha-all '^(?!amq\.).*' '{"ha-mode": "all"}'

rabbitmqctl start_app

