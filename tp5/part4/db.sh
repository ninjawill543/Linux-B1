#!/bin/bash

MYSQL_ROOT_PASSWORD=abcd1234
MYSQL_USER_NAME=nextcloud
MYSQL_USER_PASSWORD=pewpewpew
WEB_IP="10.105.1.11"
DB_NAME=nextcloud

dnf install mariadb-server -y
systemctl enable mariadb
systemctl start mariadb

sudo firewall-cmd --add-port=3306/tcp --permanent
sudo firewall-cmd --reload
sudo mysql -u root -p

CREATE USER "$MYSQL_USER_NAME"@"$WEB_IP" IDENTIFIED BY "$MYSQL_USER_PASSWORD";
CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
GRANT ALL PRIVILEGES ON $DB_NAME.* TO "$MYSQL_USER_NAME"@"$WEB_IP";
FLUSH PRIVILEGES;