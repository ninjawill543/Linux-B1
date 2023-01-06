# Module 2 : Sauvegarde du système de fichiers


## I. Script de backup

Partie à réaliser sur `web.tp6.linux`.

### 1. Ecriture du script

🌞 **Ecrire le script `bash`**

```
[user1@web ~]$ cat /srv/tp6_backup.sh 
#!/bin/bash

# This script was written by Lucas Hanson on the 6th of January 2023. 
# The script backs up the most important files of the nextcloud folder by archiving the themes, data and config files, and placing the backup in the /srv/backup folder 

[[ -d /srv/backup ]] || mkdir /srv/backup
dnf install tar -y
cd /var/www/tp5_nextcloud/
tar -czf /srv/backup/nextcloud_$( date '+%Y-%m-%d_%H-%M-%S' ).tar.gz themes/ data/ config/
```

➜ **Environnement d'exécution du script**




### 3. Service et timer

🌞 **Créez un *service*** système qui lance le script

```
[user1@web ~]$ cat /etc/systemd/system/backup.service
[Unit]
Description=Backs up nextcloud files

[Service]
ExecStart=/srv/tp6_backup.sh
Type=oneshot

[Install]
WantedBy=multi-user.target
```

🌞 **Créez un *timer*** système qui lance le *service* à intervalles réguliers

```
[user1@web ~]$ cat /etc/systemd/system/backup.timer
[Unit]
Description=Run backup service

[Timer]
OnCalendar=*-*-* 4:00:00

[Install]
WantedBy=timers.target
```
```
[user1@web ~]$ sudo systemctl list-timers
NEXT                        LEFT         LAST                        PASSED       UNIT              >
Fri 2023-01-06 16:00:30 CET 1h 5min left Fri 2023-01-06 14:21:17 CET 34min ago    dnf-makecache.time>
Sat 2023-01-07 00:00:00 CET 9h left      Fri 2023-01-06 13:45:04 CET 1h 10min ago logrotate.timer   >
Sat 2023-01-07 04:00:00 CET 13h left     n/a                         n/a          backup.timer      >
Sat 2023-01-07 14:00:07 CET 23h left     Fri 2023-01-06 14:00:07 CET 55min ago    systemd-tmpfiles-c>

4 timers listed.
Pass --all to see loaded but inactive timers, too.
```

## II. NFS

### 1. Serveur NFS

> On a déjà fait ça au TP4 ensemble :)

🖥️ **VM `storage.tp6.linux`**

**N'oubliez pas de dérouler la [📝**checklist**📝](../../2/README.md#checklist).**

🌞 **Préparer un dossier à partager sur le réseau** (sur la machine `storage.tp6.linux`)

```
[user1@storage ~]$ sudo mkdir -p /srv/nfs_shares/web.tp6.linux/
```

🌞 **Installer le serveur NFS** (sur la machine `storage.tp6.linux`)

```
[user1@storage ~]$ sudo dnf install nfs-utils -y
```
```
[user1@storage ~]$ sudo systemctl enable nfs-server
```
```
[user1@storage ~]$ sudo systemctl start nfs-server
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
```
```
[user1@storage ~]$ sudo systemctl start nfs-server
```
```
[user1@storage ~]$ sudo firewall-cmd --permanent --add-service=nfs
success
```
```
[user1@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
```
```
[user1@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
```
```
[user1@storage ~]$ sudo firewall-cmd --reload
success
```
```
[user1@storage ~]$ cat /etc/exports
/srv/nfs_shares/web.tp6.linux/	10.105.1.11(rw,sync,no_root_squash,insecure)
```

### 2. Client NFS

🌞 **Installer un client NFS sur `web.tp6.linux`**

```
[user1@web ~]$ sudo dnf install nfs-utils -y
```
```
[user1@web ~]$ sudo firewall-cmd --permanent --zone=home --add-source=10.105.1.20
success
```
```
[user1@web ~]$ sudo firewall-cmd --reload
```
```
[user1@web ~]$ sudo mount 10.105.1.20:/srv/nfs_shares/web.tp6.linux/ /srv/backup/
```

```
[user1@web ~]$ cat /etc/fstab

#
# /etc/fstab
# Created by anaconda on Sat Oct 15 12:47:23 2022
#
# Accessible filesystems, by reference, are maintained under '/dev/disk/'.
# See man pages fstab(5), findfs(8), mount(8) and/or blkid(8) for more info.
#
# After editing this file, run 'systemctl daemon-reload' to update systemd
# units generated from this file.
#
/dev/mapper/rl-root     /                       xfs     defaults        0 0
UUID=2df805a9-4569-4da4-8afe-e3ee298680df /boot                   xfs     defaults        0 0
/dev/mapper/rl-swap     none                    swap    defaults        0 0

10.105.1.20:/srv/nfs_shares/web.tp6.linux/ /srv/backup/ ext4 defaults 0 0
```

🌞 **Tester la restauration des données** sinon ça sert à rien :)

- livrez-moi la suite de commande que vous utiliseriez pour restaurer les données dans une version antérieure

![Backup everything](../pics/backup_everything.jpg)
