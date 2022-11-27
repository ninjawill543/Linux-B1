# TP2 : Appréhender l'environnement Linux



🌞 **S'assurer que le service `sshd` est démarré**


```
[user1@linuxtp2 ~]$ systemctl status sshd
● sshd.service - OpenSSH server daemon
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-11-22 15:33:29 CET; 1min 58s ago
       Docs: man:sshd(8)
             man:sshd_config(5)
   Main PID: 695 (sshd)
      Tasks: 1 (limit: 5905)
     Memory: 5.6M
        CPU: 80ms
     CGroup: /system.slice/sshd.service
             └─695 "sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups"

Nov 22 15:33:29 linuxtp2 systemd[1]: Starting OpenSSH server daemon...
Nov 22 15:33:29 linuxtp2 sshd[695]: Server listening on 0.0.0.0 port 22.
Nov 22 15:33:29 linuxtp2 sshd[695]: Server listening on :: port 22.
Nov 22 15:33:29 linuxtp2 systemd[1]: Started OpenSSH server daemon.
Nov 22 15:33:49 linuxtp2 sshd[849]: Accepted password for user1 from 10.2.2.0 port 55936 ssh2
Nov 22 15:33:49 linuxtp2 sshd[849]: pam_unix(sshd:session): session opened for user user1(uid=1000) >
```

🌞 **Analyser les processus liés au service SSH**



```
[user1@linuxtp2 ~]$ ps -ef | grep sshd
root         898       1  0 16:25 ?        00:00:00 sshd: /usr/sbin/sshd -D [listener] 0 of 10-100 startups
root         899     898  0 16:25 ?        00:00:00 sshd: user1 [priv]
user1        903     899  0 16:25 ?        00:00:00 sshd: user1@pts/0
user1      10678     904  0 17:07 pts/0    00:00:00 grep --color=auto sshd
```



🌞 **Déterminer le port sur lequel écoute le service SSH*
```
[user1@linuxtp2 ~]$ ss -t
State                  Recv-Q                  Send-Q                                   Local Address:Port                                    Peer Address:Port                   Process                  
ESTAB                  0                       0                                             10.2.2.1:ssh                                         10.2.2.0:55936                                           
```

```
[user1@linuxtp2 ~]$ ss -alnpt
State      Recv-Q     Send-Q          Local Address:Port           Peer Address:Port     Process     
LISTEN     0          128                   0.0.0.0:22                0.0.0.0:*                    
```


🌞 **Consulter les logs du service SSH**

```
[user1@linuxtp2 log]$ journalctl | grep sshd
Nov 22 15:33:28 linuxtp2 systemd[1]: Created slice Slice /system/sshd-keygen.
Nov 22 15:33:29 linuxtp2 systemd[1]: Reached target sshd-keygen.target.
Nov 22 15:33:29 linuxtp2 sshd[695]: Server listening on 0.0.0.0 port 22.
Nov 22 15:33:29 linuxtp2 sshd[695]: Server listening on :: port 22.
Nov 22 15:33:49 linuxtp2 sshd[849]: Accepted password for user1 from 10.2.2.0 port 55936 ssh2
Nov 22 15:33:49 linuxtp2 sshd[849]: pam_unix(sshd:session): session opened for user user1(uid=1000) by (uid=0)
```


## 2. Modification du service


🌞 **Identifier le fichier de configuration du serveur SSH**

```
/etc/ssh/sshd_config
```

🌞 **Modifier le fichier de conf**

```
[user1@linuxtp2 ~]$ sudo cat /etc/ssh/sshd_config | grep Port
Port 1370
```

```
[user1@linuxtp2 ~]$ sudo firewall-cmd --list-all | grep ports
  ports: 1370/tcp
```

🌞 **Redémarrer le service**

```
[user1@linuxtp2 ~]$ sudo systemctl restart sshd
```

🌞 **Effectuer une connexion SSH sur le nouveau port**
```
m4ul@thinkpad:~$ ssh user1@10.2.2.1 -p 1370
```

✨ **Bonus : affiner la conf du serveur SSH**

```
PermitRootLogin no
PermitEmptyPasswords no
GSSAPIAuthentication no
KerberosAuthentication no
HostbasedAuthentication no
ChallengeResponseAuthentication no

Compression delayed
X11Forwarding no
AllowTcpForwarding no
GatewayPorts no
PermitTunnel no
TCPKeepAlive yes

GSSAPIAuthentication yes
GSSAPICleanupCredentials no
```



# II. Service HTTP


🌞 **Installer le serveur NGINX**

```
[user1@linuxtp2 ~]$ sudo dnf install nginx
```


🌞 **Démarrer le service NGINX**

```
[user1@linuxtp2 ~]$ sudo systemctl start nginx
```

🌞 **Déterminer sur quel port tourne NGINX**


```
[user1@linuxtp2 ~]$ ss -altnp | grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*          
LISTEN 0      511             [::]:80           [::]:*          
```

```
[user1@linuxtp2 ~]$ sudo firewall-cmd --list-all | grep 80
  ports: 1370/tcp 80/tcp
```

🌞 **Déterminer les processus liés à l'exécution de NGINX**



```
[user1@linuxtp2 ~]$ ps -ef | grep nginx
root       10559       1  0 16:43 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      10560   10559  0 16:43 ?        00:00:00 nginx: worker process
user1      10676     904  0 17:06 pts/0    00:00:00 grep --color=auto nginx
```

🌞 **Euh wait**


```
m4ul@thinkpad:~$ curl 10.2.2.1 | head
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7<!doctype html>   0     0      0      0 --:--:-- --:--:-- --:--:--     0
6<html>
2  <head>
0    <meta charset='utf-8'>
     <meta name='viewport' content='width=device-width, initial-scale=1'>
     <title>HTTP Server Test Page powered by: Rocky Linux</title>
1    <style type="text/css">
0      /*<![CDATA[*/
0      
       html {
```

## 2. Analyser la conf de NGINX

🌞 **Déterminer le path du fichier de configuration de NGINX**


```
[user1@linuxtp2 ~]$ ls -al /etc/nginx/nginx.conf
-rw-r--r--. 1 root root 2334 May 16  2022 /etc/nginx/nginx.conf
```

🌞 **Trouver dans le fichier de conf**


```
[user1@linuxtp2 ~]$ cat /etc/nginx/nginx.conf | grep server -A 10
    server {
        listen       80;
        listen       [::]:80;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        error_page 404 /404.html;
        location = /404.html {
        }

        error_page 500 502 503 504 /50x.html;
        location = /50x.html {
        }
    }
```

```
[user1@linuxtp2 ~]$ cat /etc/nginx/nginx.conf | grep conf
# For more information on configuration, see:
include /usr/share/nginx/modules/*.conf;
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;
#        # Load configuration files for the default server block.
#        include /etc/nginx/default.d/*.conf;
```

## 3. Déployer un nouveau site web

🌞 **Créer un site web**

```
[user1@linuxtp2 ~]$ mkdir /var/www/tp2_linux
[user1@linuxtp2 ~]$ nano /var/www/tp2_linux/index.html
```

🌞 **Adapter la conf NGINX**
```
[user1@linuxtp2 ~]$ cat /etc/nginx/nginx.conf

user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/doc/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include		/etc/nginx/test/*;

    }

```

```
[user1@linuxtp2 ~]$ cat /etc/nginx/test/test.conf 
server {
  listen 15539;

  root /var/www/tp2_linux;
}
```

```
[user1@linuxtp2 ~]$ sudo firewall-cmd --add-port=15539/tcp --permanent^C
[user1@linuxtp2 ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
```

🌞 **Visitez votre super site web**

```
m4ul@thinkpad:~$ curl 10.2.2.1:15539
<h1>MEOW mon premier serveur web</h1>
```

# III. Your own services


## 1. Au cas où vous auriez oublié

```
[user1@linuxtp2 ~]$ sudo firewall-cmd --add-port=8888/tcp --permanent
```

## 2. Analyse des services existants


🌞 **Afficher le fichier de service SSH**

```
[user1@linuxtp2 ~]$ systemctl status sshd | grep Loaded
     Loaded: loaded (/usr/lib/systemd/system/sshd.service; enabled; vendor preset: enabled)
```

🌞 **Afficher le fichier de service NGINX**


```
[user1@linuxtp2 ~]$ cat /usr/lib/systemd/system/sshd.service | grep ExecStart=
ExecStart=/usr/sbin/sshd -D $OPTIONS

```


## 3. Création de service


🌞 **Créez le fichier `/etc/systemd/system/tp2_nc.service`**

```
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 7501
```

🌞 **Indiquer au système qu'on a modifié les fichiers de service**

```
[user1@linuxtp2 ~]$ sudo systemctl daemon-reload
```

🌞 **Démarrer notre service de ouf**

```
[user1@linuxtp2 ~]$ sudo systemctl start tp2_nc
```

🌞 **Vérifier que ça fonctionne**

```
[user1@linuxtp2 ~]$ sudo systemctl status tp2_nc
● tp2_nc.service - Super netcat tout fou
     Loaded: loaded (/etc/systemd/system/tp2_nc.service; static)
     Active: active (running) since Fri 2022-11-25 16:41:42 CET; 1min 51s ago
   Main PID: 1794 (nc)
      Tasks: 1 (limit: 5905)
     Memory: 792.0K
        CPU: 2ms
     CGroup: /system.slice/tp2_nc.service
             └─1794 /usr/bin/nc -l 7501

Nov 25 16:41:42 linuxtp2 systemd[1]: Started Super netcat tout fou.
```
```
[user1@linuxtp2 ~]$ ss -lntp | grep 7501
LISTEN 0      10           0.0.0.0:7501       0.0.0.0:*          
LISTEN 0      10              [::]:7501          [::]:* 
```

🌞 **Les logs de votre service**

```
[user1@linuxtp2 ~]$ sudo journalctl -xe -u tp2_nc | grep Started
Nov 25 16:41:42 linuxtp2 systemd[1]: Started Super netcat tout fou.
```

```
[user1@linuxtp2 ~]$ sudo journalctl -xe -u tp2_nc | grep hello
Nov 25 16:45:21 linuxtp2 nc[1794]: hello
Nov 25 16:52:01 linuxtp2 nc[1936]: hello
```

```
[user1@linuxtp2 ~]$ sudo journalctl -xe -u tp2_nc | grep Deact
Nov 25 16:45:41 linuxtp2 systemd[1]: tp2_nc.service: Deactivated successfully.
```

🌞 **Affiner la définition du service**

```
[user1@linuxtp2 ~]$ sudo cat /etc/systemd/system/tp2_nc.service
[Unit]
Description=Super netcat tout fou

[Service]
ExecStart=/usr/bin/nc -l 7501
Restart=always
```
