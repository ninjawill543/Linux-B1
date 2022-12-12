# Partie 2 : Serveur de partage de fichiers


🌞 **Donnez les commandes réalisées sur le serveur NFS `storage.tp4.linux`**

```
[user1@storage ~]$ sudo dnf install nfs-utils
```

```
[user1@storage ~]$ sudo mkdir /mnt/storage/site_web_1
[user1@storage ~]$ sudo mkdir /mnt/storage/site_web_2
```

```
[user1@storage ~]$ sudo systemctl enable nfs-server
[user1@storage ~]$ sudo systemctl start nfs-server
[user1@storage ~]$ sudo !!
sudo firewall-cmd --permanent --add-service=nfs
success
[user1@storage ~]$ sudo firewall-cmd --permanent --add-service=mountd
success
[user1@storage ~]$ sudo firewall-cmd --permanent --add-service=rpc-bind
success
[user1@storage ~]$ sudo firewall-cmd --reload
success
[user1@storage ~]$ sudo firewall-cmd --permanent --list-all | grep services
  services: cockpit dhcpv6-client mountd nfs rpc-bind ssh
```


```
[user1@storage ~]$ cat /etc/exports
/mnt/storage/site_web_1/	192.168.1.2(rw,sync,no_root_squash,no_subtree_check)
/mnt/storage/site_web_2/	192.168.1.2(rw,sync,no_root_squash,no_subtree_check)
```


🌞 **Donnez les commandes réalisées sur le client NFS `web.tp4.linux`**
```
[user1@web ~]$ sudo dnf install nfs-utils
```

```
[user1@web ~]$ sudo mkdir -p /var/www/site_web_1/
[user1@web ~]$ sudo mkdir -p /var/www/site_web_2/
[user1@web ~]$ sudo mount 192.168.1.3:/mnt/storage/site_web_1/ /var/www/site_web_1/
[user1@web ~]$ sudo mount 192.168.1.3:/mnt/storage/site_web_2/ /var/www/site_web_2/
```

```
[user1@web ~]$ df -h | grep storage
192.168.1.3:/mnt/storage/site_web_1  2.0G     0  1.9G   0% /var/www/site_web_1
192.168.1.3:/mnt/storage/site_web_2  2.0G     0  1.9G   0% /var/www/site_web_2
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
192.168.1.3:/mnt/storage/site_web_1 /var/www/site_web_1/ ext4 defaults 0 0
192.168.1.3:/mnt/storage/site_web_2 /var/www/site_web_2/ ext4 defaults 0 0
```
