#!/bin/bash

hostname web
echo 'web' > /etc/hostname
dnf install httpd -y
systemctl start httpd
systemctl enable httpd
firewall-cmd --add-port=80/tcp --permanent
firewall-cmd --reload

dnf config-manager --set-enabled crb
dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
dnf module list php -y
dnf module enable php:remi-8.1 -y
dnf install -y php81-php
dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp
mkdir /var/www/tp5_nextcloud
dnf install wget -y
dnf install unzip -y
cd /var/www/tp5_nextcloud/
wget https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
unzip nextcloud-25.0.0rc3.zip
cd nextcloud/
sudo mv * ..
chown apache *
cd ..
chown apache *
cd
cp nextcloud.conf /etc/httpd/conf.d/
systemctl restart httpd