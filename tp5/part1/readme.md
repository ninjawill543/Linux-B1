# Partie 1 : Mise en place et maîtrise du serveur Web

## 1. Installation

🖥️ **VM web.tp5.linux**

**N'oubliez pas de dérouler la [📝**checklist**📝](../README.md#checklist).**

| Machine         | IP            | Service     |
|-----------------|---------------|-------------|
| `web.tp5.linux` | `10.105.1.11` | Serveur Web |

🌞 **Installer le serveur Apache**

```
[user1@web ~]$ sudo dnf install httpd -y
```
🌞 **Démarrer le service Apache**


```
[user1@web ~]$ sudo systemctl start httpd
[user1@web ~]$ sudo systemctl enable httpd
Created symlink /etc/systemd/system/multi-user.target.wants/httpd.service → /usr/lib/systemd/system/httpd.service.
[user1@web ~]$ sudo firewall-cmd --add-port=80/tcp --permanent
success
[user1@web ~]$ sudo firewall-cmd --reload
success
[user1@web ~]$ sudo ss -ltunp | grep httpd
tcp   LISTEN 0      511                *:80              *:*    users:(("httpd",pid=1698,fd=4),("httpd",pid=1697,fd=4),("httpd",pid=1696,fd=4),("httpd",pid=1694,fd=4))
```

🌞 **TEST**

```
[user1@web ~]$ sudo systemctl status httpd
● httpd.service - The Apache HTTP Server
     Loaded: loaded (/usr/lib/systemd/system/httpd.service; enabled; vendor preset: disabled)
     Active: active (running) since Wed 2022-12-21 11:28:26 CET; 4min 9s ago
       Docs: man:httpd.service(8)
   Main PID: 1694 (httpd)
     Status: "Total requests: 0; Idle/Busy workers 100/0;Requests/sec: 0; Bytes served/sec:   0 B/se>
      Tasks: 213 (limit: 4638)
     Memory: 23.3M
        CPU: 157ms
     CGroup: /system.slice/httpd.service
             ├─1694 /usr/sbin/httpd -DFOREGROUND
             ├─1695 /usr/sbin/httpd -DFOREGROUND
             ├─1696 /usr/sbin/httpd -DFOREGROUND
             ├─1697 /usr/sbin/httpd -DFOREGROUND
             └─1698 /usr/sbin/httpd -DFOREGROUND

Dec 21 11:28:26 web systemd[1]: Starting The Apache HTTP Server...
Dec 21 11:28:26 web httpd[1694]: AH00558: httpd: Could not reliably determine the server's fully qua>
Dec 21 11:28:26 web systemd[1]: Started The Apache HTTP Server.
Dec 21 11:28:26 web httpd[1694]: Server configured, listening on: port 80
```
```
[user1@web ~]$ curl localhost | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0   620k      0 --:--:-- --:--:-- --:--:--  676k
      </div>
      </div>
      
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>
      
  </body>
</html>
```
```
m4ul@thinkpad:~$ curl 10.105.1.11 | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  7679k      0 --:--:-- --:--:-- --:--:-- 7441k
      </div>
      </div>
      
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>
      
  </body>
</html>

```


## 2. Avancer vers la maîtrise du service

🌞 **Le service Apache...**
```
[user1@web ~]$ cat /usr/lib/systemd/system/httpd.service
# See httpd.service(8) for more information on using the httpd service.

# Modifying this file in-place is not recommended, because changes
# will be overwritten during package upgrades.  To customize the
# behaviour, run "systemctl edit httpd" to create an override unit.

# For example, to pass additional options (such as -D definitions) to
# the httpd binary at startup, create an override unit (as is done by
# systemctl edit) and enter the following:

#	[Service]
#	Environment=OPTIONS=-DMY_DEFINE

[Unit]
Description=The Apache HTTP Server
Wants=httpd-init.service
After=network.target remote-fs.target nss-lookup.target httpd-init.service
Documentation=man:httpd.service(8)

[Service]
Type=notify
Environment=LANG=C

ExecStart=/usr/sbin/httpd $OPTIONS -DFOREGROUND
ExecReload=/usr/sbin/httpd $OPTIONS -k graceful
# Send SIGWINCH for graceful stop
KillSignal=SIGWINCH
KillMode=mixed
PrivateTmp=true
OOMPolicy=continue

[Install]
WantedBy=multi-user.target
```

🌞 **Déterminer sous quel utilisateur tourne le processus Apache**

```
[user1@web ~]$ cat /etc/httpd/conf/httpd.conf | grep User | head -n 1
User apache
```

```
[user1@web ~]$ ps -ef | grep httpd | head -n 2 | tail -n 1
apache      1695    1694  0 11:28 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
```

```
[user1@web ~]$ ls -al /usr/share/testpage/
total 12
drwxr-xr-x.  2 root root   24 Dec 21 11:25 .
drwxr-xr-x. 81 root root 4096 Dec 21 11:25 ..
-rw-r--r--.  1 root root 7620 Jul 27 20:05 index.html
```


🌞 **Changer l'utilisateur utilisé par Apache**

```
[user1@web ~]$ sudo useradd apac

[user1@web ~]$ cat /etc/httpd/conf/httpd.conf | grep User | head -n 1
User apac

[user1@web ~]$ ps -ef | grep httpd
root        2104       1  0 11:43 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apac        2105    2104  0 11:43 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apac        2106    2104  0 11:43 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apac        2107    2104  0 11:43 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
apac        2108    2104  0 11:43 ?        00:00:00 /usr/sbin/httpd -DFOREGROUND
```

🌞 **Faites en sorte que Apache tourne sur un autre port**

```
[user1@web ~]$ sudo firewall-cmd --remove-port=80/tcp --permanent
success
[user1@web ~]$ sudo firewall-cmd --add-port=81/tcp --permanent
success
[user1@web ~]$ sudo firewall-cmd --reload
success
[user1@web ~]$ cat /etc/httpd/conf/httpd.conf | grep Listen
Listen 81
[user1@web ~]$ sudo systemctl restart httpd
[user1@web ~]$ sudo ss -ltunp | grep httpd
tcp   LISTEN 0      511                *:81              *:*    users:(("httpd",pid=2597,fd=4),("httpd",pid=2596,fd=4),("httpd",pid=2595,fd=4),("httpd",pid=2593,fd=4))
```

```
m4ul@thinkpad:~$ curl 10.105.1.11:81 | tail
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100  7620  100  7620    0     0  9267k      0 --:--:-- --:--:-- --:--:-- 7441k
      </div>
      </div>
      
      <footer class="col-sm-12">
      <a href="https://apache.org">Apache&trade;</a> is a registered trademark of <a href="https://apache.org">the Apache Software Foundation</a> in the United States and/or other countries.<br />
      <a href="https://nginx.org">NGINX&trade;</a> is a registered trademark of <a href="https://">F5 Networks, Inc.</a>.
      </footer>
      
  </body>
</html>
```



📁 **Fichier `/etc/httpd/conf/httpd.conf`**

➜ **Si c'est tout bon vous pouvez passer à [la partie 2.](../part2/README.md)**
