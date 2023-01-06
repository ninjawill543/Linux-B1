# Partie 2 : Mise en place et maîtrise du serveur de base de données

🖥️ **VM db.tp5.linux**

**N'oubliez pas de dérouler la [📝**checklist**📝](#checklist).**

| Machines        | IP            | Service                 |
|-----------------|---------------|-------------------------|
| `web.tp5.linux` | `10.105.1.11` | Serveur Web             |
| `db.tp5.linux`  | `10.105.1.12` | Serveur Base de Données |

🌞 **Install de MariaDB sur `db.tp5.linux`**

```
[user1@db ~]$ sudo dnf install mariadb-server -y
[user1@db ~]$ sudo systemctl enable mariadb
[user1@db ~]$ sudo systemctl start mariadb
```


🌞 **Port utilisé par MariaDB**

```
[user1@db ~]$ sudo ss -ltunp | grep mariadb
tcp   LISTEN 0      80                 *:3306            *:*    users:(("mariadbd",pid=3615,fd=19))
```

```
[user1@db ~]$ sudo firewall-cmd --add-port=3306/tcp --permanent
success
[user1@db ~]$ sudo firewall-cmd --reload
success
```

🌞 **Processus liés à MariaDB**

```
[user1@db ~]$ ps -ef | grep maria
mysql       3615       1  0 11:53 ?        00:00:00 /usr/libexec/mariadbd --basedir=/usr
```

➜ **Une fois la db en place, go sur [la partie 3.](../part3/README.md)**
