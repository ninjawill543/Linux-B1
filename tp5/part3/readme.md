# Partie 3 : Configuration et mise en place de NextCloud



## 1. Base de données



🌞 **Préparation de la base pour NextCloud**

```
[user1@db ~]$ sudo mysql -u root -p
Enter password: 
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MariaDB connection id is 12
Server version: 10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MariaDB [(none)]> CREATE USER 'nextcloud'@'10.105.1.11' IDENTIFIED BY 'pewpewpew';
Query OK, 0 rows affected (0.004 sec)

MariaDB [(none)]> CREATE DATABASE IF NOT EXISTS nextcloud CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci;
Query OK, 1 row affected (0.001 sec)

MariaDB [(none)]> GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextcloud'@'10.105.1.11';
Query OK, 0 rows affected (0.011 sec)

MariaDB [(none)]> FLUSH PRIVILEGES;
Query OK, 0 rows affected (0.001 sec)
```


🌞 **Exploration de la base de données**

```
[user1@web ~]$ mysql -u nextcloud -h 10.105.1.12 -p
Enter password: 
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 16
Server version: 5.5.5-10.5.16-MariaDB MariaDB Server

Copyright (c) 2000, 2022, Oracle and/or its affiliates.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> SHOW DATABASES;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| nextcloud          |
+--------------------+
2 rows in set (0.00 sec)

mysql> use nextcloud;
Database changed
mysql> show tables;
Empty set (0.01 sec)
```


🌞 **Trouver une commande SQL qui permet de lister tous les utilisateurs de la base de données**

```
MariaDB [(none)]> SELECT user FROM mysql.user;
+-------------+
| User        |
+-------------+
| nextcloud   |
| mariadb.sys |
| mysql       |
| root        |
+-------------+
4 rows in set (0.001 sec)
```



## 2. Serveur Web et NextCloud

⚠️⚠️⚠️ **N'OUBLIEZ PAS de réinitialiser votre conf Apache avant de continuer. En particulier, remettez le port et le user par défaut.**

🌞 **Install de PHP**

```
[user1@web ~]$ sudo dnf config-manager --set-enabled crb
[user1@web ~]$ sudo dnf install dnf-utils http://rpms.remirepo.net/enterprise/remi-release-9.rpm -y
[user1@web ~]$ dnf module list php -y
[user1@web ~]$ sudo dnf module enable php:remi-8.1 -y
[user1@web ~]$ sudo dnf install -y php81-php
```


🌞 **Install de tous les modules PHP nécessaires pour NextCloud**

```
[user1@web ~]$ sudo dnf install -y libxml2 openssl php81-php php81-php-ctype php81-php-curl php81-php-gd php81-php-iconv php81-php-json php81-php-libxml php81-php-mbstring php81-php-openssl php81-php-posix php81-php-session php81-php-xml php81-php-zip php81-php-zlib php81-php-pdo php81-php-mysqlnd php81-php-intl php81-php-bcmath php81-php-gmp
```

🌞 **Récupérer NextCloud**

```
[user1@web ~]$ sudo mkdir /var/www/tp5_nextcloud
```

```
[user1@web ~]$ sudo dnf install wget -y
[user1@web ~]$ sudo dnf install unzip -y
```

```
[user1@web ~]$ cd /var/www/tp5_nextcloud/
[user1@web ~]$ sudo wget https://download.nextcloud.com/server/prereleases/nextcloud-25.0.0rc3.zip
[user1@web ~]$ sudo unzip nextcloud-25.0.0rc3.zip
[user1@web ~]$ cd nextcloud/
[user1@web ~]$ sudo mv * ..
```

```
[user1@web ~]$ sudo chown apache *
[user1@web ~]$ sudo chown apache *
```

```
[user1@web tp5_nextcloud]$ ls -al
total 132
drwxr-xr-x. 14 root   root  4096 Dec 21 12:11 .
drwxr-xr-x.  5 root   root    54 Dec 21 12:09 ..
drwxr-xr-x. 47 apache root  4096 Oct  6 14:47 3rdparty
drwxr-xr-x. 50 apache root  4096 Oct  6 14:44 apps
-rw-r--r--.  1 apache root 19327 Oct  6 14:42 AUTHORS
drwxr-xr-x.  2 apache root    67 Oct  6 14:47 config
-rw-r--r--.  1 apache root  4095 Oct  6 14:42 console.php
-rw-r--r--.  1 apache root 34520 Oct  6 14:42 COPYING
drwxr-xr-x. 23 apache root  4096 Oct  6 14:47 core
-rw-r--r--.  1 apache root  6317 Oct  6 14:42 cron.php
drwxr-xr-x.  2 apache root  8192 Oct  6 14:42 dist
-rw-r--r--.  1 apache root   156 Oct  6 14:42 index.html
-rw-r--r--.  1 apache root  3456 Oct  6 14:42 index.php
drwxr-xr-x.  6 apache root   125 Oct  6 14:42 lib
-rw-r--r--.  1 apache root   283 Oct  6 14:42 occ
drwxr-xr-x.  2 apache root    23 Oct  6 14:42 ocm-provider
drwxr-xr-x.  2 apache root    55 Oct  6 14:42 ocs
drwxr-xr-x.  2 apache root    23 Oct  6 14:42 ocs-provider
-rw-r--r--.  1 apache root  3139 Oct  6 14:42 public.php
-rw-r--r--.  1 apache root  5426 Oct  6 14:42 remote.php
drwxr-xr-x.  4 apache root   133 Oct  6 14:42 resources
-rw-r--r--.  1 apache root    26 Oct  6 14:42 robots.txt
-rw-r--r--.  1 apache root  2452 Oct  6 14:42 status.php
drwxr-xr-x.  3 apache root    35 Oct  6 14:42 themes
drwxr-xr-x.  2 apache root    43 Oct  6 14:44 updater
-rw-r--r--.  1 apache root   387 Oct  6 14:47 version.php
[user1@web tp5_nextcloud]$ cd ..
[user1@web www]$ ls -al
total 8
drwxr-xr-x.  5 root   root   54 Dec 21 12:09 .
drwxr-xr-x. 20 root   root 4096 Dec 21 11:25 ..
drwxr-xr-x.  2 root   root    6 Nov 16 08:11 cgi-bin
drwxr-xr-x.  2 root   root    6 Nov 16 08:11 html
drwxr-xr-x. 14 apache root 4096 Dec 21 12:11 tp5_nextcloud

```


🌞 **Adapter la configuration d'Apache**

```
[user1@web ~]$ cat /etc/httpd/conf.d/nextcloud.conf 
<VirtualHost *:80>
  # on indique le chemin de notre webroot
  DocumentRoot /var/www/tp5_nextcloud/
  # on précise le nom que saisissent les clients pour accéder au service
  ServerName  web

  # on définit des règles d'accès sur notre webroot
  <Directory /var/www/tp5_nextcloud/> 
    Require all granted
    AllowOverride All
    Options FollowSymLinks MultiViews
    <IfModule mod_dav.c>
      Dav off
    </IfModule>
  </Directory>
</VirtualHost>
```

🌞 **Redémarrer le service Apache** pour qu'il prenne en compte le nouveau fichier de conf

```
[user1@web ~]$ sudo systemctl restart httpd
```


## 3. Finaliser l'installation de NextCloud

➜ **Sur votre PC**



🌞 **Exploration de la base de données**


