#!/bin/bash -ex 

yum install -y wget 
yum install -y epel-release

yum --enablerepo=epel -y install nginx

systemctl start nginx 
systemctl enable nginx

systemctl status nginx 

cat << EOF > /usr/share/nginx/html/index.html
<html>
<body>
<div style="width: 100%; font-size: 40px; font-weight: bold; text-align: center;">
`hostname`
</div>
</body>
</html>
EOF

systemctl restart nginx 
