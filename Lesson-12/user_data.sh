#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`

cat <<EOF > /var/www/html/index.html
<html>
<body bgcolor="purple>
<h2><font color="blue">Build by Power of Terraform <font color="red"> v0.12</font></h2><br><p>
<font color="green">Server PrivateIP: <font color="agua">$myip<br><br>

<font color="yellow">
<b>Version 1.0</b>
</body>
</html>
EOF

sudo service httpd start
chkconfig httpd on