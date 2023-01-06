# Module 4 : Monitoring

Dans ce sujet on va installer un outil plutôt clé en main pour mettre en place un monitoring simple de nos machines.

L'outil qu'on va utiliser est [Netdata](https://learn.netdata.cloud/docs/agent/packaging/installer/methods/kickstart).

🌞 **Installer Netdata**

```
[user1@db ~]$ wget -O /tmp/netdata-kickstart.sh https://my-netdata.io/kickstart.sh && sh /tmp/netdata-kickstart.sh 
[user1@db ~]$ sudo systemctl start netdata
[user1@db ~]$ sudo systemctl enable netdata
[user1@db ~]$ sudo firewall-cmd --permanent --add-port=19999/tcp
success
[user1@db ~]$ sudo firewall-cmd --reload
success
[user1@db ~]$ sudo ss -ltunp | grep netdata
udp   UNCONN 0      0          127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=3296,fd=47))
udp   UNCONN 0      0              [::1]:8125          [::]:*    users:(("netdata",pid=3296,fd=46))
tcp   LISTEN 0      4096       127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=3296,fd=49))
tcp   LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*    users:(("netdata",pid=3296,fd=6)) 
tcp   LISTEN 0      4096           [::1]:8125          [::]:*    users:(("netdata",pid=3296,fd=48))
tcp   LISTEN 0      4096            [::]:19999         [::]:*    users:(("netdata",pid=3296,fd=7)) 
```



🌞 **Une fois Netdata installé et fonctionnel, déterminer :**

```
[user1@db ~]$ ps -ef | grep netdata | head -n 5 | tail -n 1
netdata     3296       1  0 16:47 ?        00:00:03 /usr/sbin/netdata -P /run/netdata/netdata.pid -D

[user1@db ~]$ sudo ss -ltunp | grep netdata
udp   UNCONN 0      0          127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=3296,fd=47))
udp   UNCONN 0      0              [::1]:8125          [::]:*    users:(("netdata",pid=3296,fd=46))
tcp   LISTEN 0      4096       127.0.0.1:8125       0.0.0.0:*    users:(("netdata",pid=3296,fd=49))
tcp   LISTEN 0      4096         0.0.0.0:19999      0.0.0.0:*    users:(("netdata",pid=3296,fd=6)) 
tcp   LISTEN 0      4096           [::1]:8125          [::]:*    users:(("netdata",pid=3296,fd=48))
tcp   LISTEN 0      4096            [::]:19999         [::]:*    users:(("netdata",pid=3296,fd=7)) 
```

➜ **Vous ne devez PAS utiliser le "Cloud Netdata"**



🌞 **Configurer Netdata pour qu'il vous envoie des alertes** 


🌞 **Vérifier que les alertes fonctionnent**


