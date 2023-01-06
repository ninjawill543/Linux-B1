# Module 3 : Fail2Ban

Fail2Ban c'est un peu le cas d'école de l'admin Linux, je vous laisse Google pour le mettre en place.

![Fail2Ban](./../pics/fail2ban.png)

C'est must-have sur n'importe quel serveur à peu de choses près. En plus d'enrayer les attaques par bruteforce, il limite aussi l'imact sur les performances de ces attaques, en bloquant complètement le trafic venant des IP considérées comme malveillantes

🌞 Faites en sorte que :

```
[user1@db ~]$ sudo systemctl status fail2ban
● fail2ban.service - Fail2Ban Service
     Loaded: loaded (/usr/lib/systemd/system/fail2ban.service; enabled; vendor preset: disabled)
     Active: active (running) since Fri 2023-01-06 15:53:09 CET; 37min ago
       Docs: man:fail2ban(1)
    Process: 2290 ExecStartPre=/bin/mkdir -p /run/fail2ban (code=exited, status=0/SUCCESS)
   Main PID: 2291 (fail2ban-server)
      Tasks: 5 (limit: 4638)
     Memory: 18.4M
        CPU: 1.660s
     CGroup: /system.slice/fail2ban.service
             └─2291 /usr/bin/python3 -s /usr/bin/fail2ban-server -xf start

Jan 06 15:53:09 db systemd[1]: Starting Fail2Ban Service...
Jan 06 15:53:09 db systemd[1]: Started Fail2Ban Service.
Jan 06 15:53:09 db fail2ban-server[2291]: 2023-01-06 15:53:09,111 fail2ban.configreader   [2291]: WA>
Jan 06 15:53:09 db fail2ban-server[2291]: Server ready
```

```
[user1@db ~]$ cat /etc/fail2ban/jail.local | head -n 108 | tail -n 9
# "bantime" is the number of seconds that a host is banned.
bantime  = 1000m

# A host is banned if it has generated "maxretry" during the last "findtime"
# seconds.
findtime  = 1m

# "maxretry" is the number of failures before a host get banned.
maxretry = 3
```

```
[user1@web ~]$ ssh user1@10.105.1.12
ssh: connect to host 10.105.1.12 port 22: Connection refused
```

```
[user1@db ~]$ sudo iptables -L -n
[sudo] password for user1: 
Chain INPUT (policy ACCEPT)
target     prot opt source               destination         
f2b-sshd   tcp  --  0.0.0.0/0            0.0.0.0/0            multiport dports 22

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination         

Chain OUTPUT (policy ACCEPT)
target     prot opt source               destination         

Chain f2b-sshd (1 references)
target     prot opt source               destination         
REJECT     all  --  10.105.1.11          0.0.0.0/0            reject-with icmp-port-unreachable
RETURN     all  --  0.0.0.0/0            0.0.0.0/0           
```

```
[user1@db ~]$ sudo fail2ban-client banned
[{'sshd': ['10.105.1.11']}]
```

```
sudo fail2ban-client set sshd unbanip 10.105.1.11
1
```

```
[user1@db ~]$ sudo fail2ban-client banned
[{'sshd': []}]
```

```
The same config was installed on all 4 machines
```
