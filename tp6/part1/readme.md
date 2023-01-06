# Module 1 : Reverse Proxy


# I. Setup

🖥️ **VM `proxy.tp6.linux`**

**N'oubliez pas de dérouler la [📝**checklist**📝](../../2/README.md#checklist).**

🌞 **On utilisera NGINX comme reverse proxy**

```
[user1@proxy ~]$ sudo dnf install nginx -y
```
```
[user1@proxy ~]$ sudo systemctl start nginx
[user1@proxy ~]$ sudo systemctl enable nginx
```
```
[user1@proxy ~]$ sudo ss -ltunp | grep nginx
tcp   LISTEN 0      511          0.0.0.0:80        0.0.0.0:*    users:(("nginx",pid=1376,fd=6),("nginx",pid=1375,fd=6))
tcp   LISTEN 0      511             [::]:80           [::]:*    users:(("nginx",pid=1376,fd=7),("nginx",pid=1375,fd=7))
```
```
[user1@proxy ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
```
```
[user1@proxy ~]$ sudo firewall-cmd --reload
success
```
```
[user1@proxy ~]$ ps -ef | grep nginx
root        1375       1  0 15:31 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx       1376    1375  0 15:31 ?        00:00:00 nginx: worker process
user1       1407    1180  0 15:33 pts/0    00:00:00 grep --color=auto nginx
```

```
m4ul@thinkpad:~$ curl 10.105.1.15:80 | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  4691k      0 --:--:-- --:--:-- --:--:-- 7441k
      </div>
      </div>
      
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>
      
  </body>
</html>
```


🌞 **Configurer NGINX**

```
[user1@proxy ~]$ cat /etc/nginx/conf.d/nginx.conf 
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp6.linux;

    # Port d'écoute de NGINX
    listen 80;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```


➜ **Modifier votre fichier `hosts` de VOTRE PC**

```
m4ul@thinkpad:~$ curl http://web.tp5.linux/
<!DOCTYPE html>
<html>
<head>
	<script> window.location.href="index.php"; </script>
	<meta http-equiv="refresh" content="0; URL=index.php">
</head>
</html>
```


🌞 **Faites en sorte de**

```
[user1@web ~]$ sudo firewall-cmd --permanent --zone=drop --change-interface=enp0s8
The interface is under control of NetworkManager, setting zone to 'drop'.
success
```
```
[user1@web ~]$ sudo firewall-cmd --permanent --zone=home --add-source=10.105.1.15
success
```
```
[user1@web ~]$ sudo firewall-cmd --reload
success
```


🌞 **Une fois que c'est en place**

```
m4ul@thinkpad:~$ ping 10.105.1.11
PING 10.105.1.11 (10.105.1.11) 56(84) bytes of data.
^C
--- 10.105.1.11 ping statistics ---
2 packets transmitted, 0 received, 100% packet loss, time 1028ms
```
```
m4ul@thinkpad:~$ ping 10.105.1.15
PING 10.105.1.15 (10.105.1.15) 56(84) bytes of data.
64 bytes from 10.105.1.15: icmp_seq=1 ttl=64 time=0.496 ms
64 bytes from 10.105.1.15: icmp_seq=2 ttl=64 time=0.475 ms
^C
--- 10.105.1.15 ping statistics ---
2 packets transmitted, 2 received, 0% packet loss, time 1015ms
rtt min/avg/max/mdev = 0.475/0.485/0.496/0.010 ms
```



# II. HTTPS


🌞 **Faire en sorte que NGINX force la connexion en HTTPS plutôt qu'HTTP**

```
[user1@proxy ~]$ openssl genrsa -aes128 2048 > server.key 
[user1@proxy ~]$ openssl rsa -in server.key -out server.key 
[user1@proxy ~]$ openssl req -utf8 -new -key server.key -out server.csr
[user1@proxy ~]$ openssl x509 -in server.csr -out server.crt -req -signkey server.key -days 3650 
[user1@proxy ~]$ chmod 600 server.key
```

```
[user1@proxy ~]$ cat /etc/nginx/conf.d/nginx.conf 
server {
    # On indique le nom que client va saisir pour accéder au service
    # Pas d'erreur ici, c'est bien le nom de web, et pas de proxy qu'on veut ici !
    server_name web.tp6.linux;

    # Port d'écoute de NGINX
    listen 443 ssl;
    server_name example.yourdomain.com;
    ssl_certificate  /home/user1/server.crt;
    ssl_certificate_key  /home/user1/server.key; 
    ssl_prefer_server_ciphers on;

    location / {
        # On définit des headers HTTP pour que le proxying se passe bien
        proxy_set_header  Host $host;
        proxy_set_header  X-Real-IP $remote_addr;
        proxy_set_header  X-Forwarded-Proto https;
        proxy_set_header  X-Forwarded-Host $remote_addr;
        proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;

        # On définit la cible du proxying 
        proxy_pass http://10.105.1.11:80;
    }

    # Deux sections location recommandés par la doc NextCloud
    location /.well-known/carddav {
      return 301 $scheme://$host/remote.php/dav;
    }

    location /.well-known/caldav {
      return 301 $scheme://$host/remote.php/dav;
    }
}
```
```
[user1@proxy ~]$ sudo systemctl restart nginx
[user1@proxy ~]$ sudo firewall-cmd --add-port=443/tcp --permanent
success
[user1@proxy ~]$ sudo firewall-cmd --reload
success
[user1@proxy ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[user1@proxy ~]$ sudo firewall-cmd --reload
success
```

```
m4ul@thinkpad:~$ curl http://web.tp5.linux/
curl: (7) Failed to connect to web.tp5.linux port 80 after 1 ms: No route to host
m4ul@thinkpad:~$ curl https://web.tp5.linux/
curl: (60) SSL certificate problem: self-signed certificate
More details here: https://curl.se/docs/sslcerts.html

curl failed to verify the legitimacy of the server and therefore could not
establish a secure connection to it. To learn more about this situation and
how to fix it, please visit the web page mentioned above.
```


