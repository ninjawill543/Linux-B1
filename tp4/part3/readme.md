# Partie 3 : Serveur web


## 1. Intro NGINX


## 2. Install

🖥️ **VM web.tp4.linux**

🌞 **Installez NGINX**

```
[user1@web ~]$ sudo dnf install nginx
```

## 3. Analyse

```
[user1@web ~]$ sudo systemctl start nginx
[user1@web ~]$ sudo systemctl status nginx
● nginx.service - The nginx HTTP and reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; disabled; vendor preset: disabled)
     Active: active (running) since Tue 2022-12-06 14:06:53 CET; 4s ago
    Process: 2168 ExecStartPre=/usr/bin/rm -f /run/nginx.pid (code=exited, status=0/SUCCESS)
    Process: 2169 ExecStartPre=/usr/sbin/nginx -t (code=exited, status=0/SUCCESS)
    Process: 2170 ExecStart=/usr/sbin/nginx (code=exited, status=0/SUCCESS)
   Main PID: 2171 (nginx)
      Tasks: 2 (limit: 4638)
     Memory: 1.9M
        CPU: 12ms
     CGroup: /system.slice/nginx.service
             ├─2171 "nginx: master process /usr/sbin/nginx"
             └─2172 "nginx: worker process"

Dec 06 14:06:53 web systemd[1]: Starting The nginx HTTP and reverse proxy server...
Dec 06 14:06:53 web nginx[2169]: nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
Dec 06 14:06:53 web nginx[2169]: nginx: configuration file /etc/nginx/nginx.conf test is successful
Dec 06 14:06:53 web systemd[1]: Started The nginx HTTP and reverse proxy server.
```

🌞 **Analysez le service NGINX**

```
[user1@web ~]$ ps -ef | grep nginx
root        2171       1  0 14:06 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       2172    2171  0 14:06 ?        00:00:00 nginx: worker process
user1       2183    1210  0 14:07 pts/0    00:00:00 grep --color=auto nginx
```
```
[user1@web ~]$ sudo ss -lntup | grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=2172,fd=6),("nginx",pid=2171,fd=6))
tcp   LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=2172,fd=7),("nginx",pid=2171,fd=7))
```
```
[user1@web ~]$ ls -al /usr/share/nginx/html/index.html 
lrwxrwxrwx. 1 root root 25 Oct 31 16:37 /usr/share/nginx/html/index.html -> ../../testpage/index.html
```

## 4. Visite du service web


🌞 **Configurez le firewall pour autoriser le trafic vers le service NGINX**

```
[user1@web ~]$ sudo firewall-cmd --zone=public --permanent --add-service=http
success
[user1@web ~]$ sudo firewall-cmd --reload
success
```

🌞 **Accéder au site web**

```
m4ul@thinkpad:~$ curl http://192.168.1.2
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
```

🌞 **Vérifier les logs d'accès**

```
[user1@web ~]$ sudo cat /var/log/nginx/access.log | tail -n 3
192.168.1.0 - - [06/Dec/2022:14:19:40 +0100] "GET /poweredby.png HTTP/1.1" 200 368 "http://192.168.1.2/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0" "-"
192.168.1.0 - - [06/Dec/2022:14:19:41 +0100] "GET /favicon.ico HTTP/1.1" 404 3332 "http://192.168.1.2/" "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:107.0) Gecko/20100101 Firefox/107.0" "-"
192.168.1.0 - - [06/Dec/2022:14:20:06 +0100] "GET / HTTP/1.1" 200 7620 "-" "curl/7.81.0" "-"
```

## 5. Modif de la conf du serveur web

🌞 **Changer le port d'écoute**

```
listen       8080;
listen       [::]:8080;
```
```
[user1@web ~]$ sudo ss -lntup | grep nginx
tcp   LISTEN 0      511          0.0.0.0:8080      0.0.0.0:*    users:(("nginx",pid=2387,fd=6),("nginx",pid=2386,fd=6))
tcp   LISTEN 0      511             [::]:8080         [::]:*    users:(("nginx",pid=2387,fd=7),("nginx",pid=2386,fd=7))
```

```
[user1@web ~]$ sudo firewall-cmd --zone=public --permanent --remove-service=http
success
[user1@web ~]$ sudo firewall-cmd --zone=public --permanent --add-port 8080/tcp
success
[user1@web ~]$ sudo firewall-cmd --reload
success
```

```
m4ul@thinkpad:~$ curl http://192.168.1.2:8080
<!doctype html>
<html>
  <head>
    <meta charset='utf-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1'>
    <title>HTTP Server Test Page powered by: Rocky Linux</title>
    <style type="text/css">
      /*<![CDATA[*/
      
```

🌞 **Changer l'utilisateur qui lance le service**

```
[user1@web ~]$ sudo useradd web
[user1@web ~]$ sudo passwd web
Changing password for user web.
```
```
[user1@web ~]$ sudo cat /etc/nginx/nginx.conf | grep user
user web;
[user1@web ~]$ ps -ef | grep nginx
root        2587       1  0 14:35 ?        00:00:00 nginx: master process /usr/sbin/nginx
web         2588    2587  0 14:35 ?        00:00:00 nginx: worker process
user1       2596    1210  0 14:35 pts/0    00:00:00 grep --color=auto nginx
```

**Il est temps d'utiliser ce qu'on a fait à la partie 2 !**

🌞 **Changer l'emplacement de la racine Web**

```
[user1@web ~]$ sudo cat /etc/nginx/nginx.conf | grep web
        root         /var/www/site_web_1/;
```

## 6. Deux sites web sur un seul serveur


🌞 **Repérez dans le fichier de conf**

```
[user1@web ~]$ sudo cat /etc/nginx/nginx.conf | grep conf.d
    # Load modular configuration files from the /etc/nginx/conf.d directory.
    include /etc/nginx/conf.d/*.conf;
```
🌞 **Créez le fichier de configuration pour le premier site**

```
[user1@web ~]$ cat /etc/nginx/conf.d/site_web_1.conf 
server {
	listen       8080;
        listen       [::]:8080;
        server_name  _;
        root         /var/www/site_web_1/;

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

🌞 **Créez le fichier de configuration pour le deuxième site**

```
[user1@web ~]$ cat /etc/nginx/conf.d/site_web_2.conf 
server {
        listen       8888;
        listen       [::]:8888;
        server_name  _;
        root         /var/www/site_web_2/;

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
[user1@web ~]$ sudo firewall-cmd --zone=public --permanent --add-port 8888/tcp
success
[user1@web ~]$ sudo systemctl restart nginx
[user1@web ~]$ sudo firewall-cmd --reload
success
```

🌞 **Prouvez que les deux sites sont disponibles**

```
m4ul@thinkpad:~$ curl http://192.168.1.2:8080
 <!DOCTYPE html>
<html>
<body>

<h1>HEHEHE</h1>

</body>
</html> 
m4ul@thinkpad:~$ curl http://192.168.1.2:8888
 <!DOCTYPE html>
<html>
<body>

<h1>2</h1>

</body>
</html>
```
