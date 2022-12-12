# Partie 1 : Partitionnement du serveur de stockage

🌞 **Partitionner le disque à l'aide de LVM**

```
[user1@storage ~]$ sudo pvcreate /dev/sdb
[sudo] password for user1: 
  Physical volume "/dev/sdb" successfully created.
```
```
[user1@storage ~]$ sudo pvs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBb82e9ad1-30a0508e_ PVID bTTF5ek2AUZ2PZjuz1mLgyDy39lqp5wo last seen on /dev/sda2 not found.
  PV         VG Fmt  Attr PSize PFree
  /dev/sdb      lvm2 ---  2.00g 2.00g
```

```
[user1@storage ~]$ sudo vgcreate storage /dev/sdb
  Volume group "storage" successfully created
```

```
[user1@storage ~]$ sudo vgs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBb82e9ad1-30a0508e_ PVID bTTF5ek2AUZ2PZjuz1mLgyDy39lqp5wo last seen on /dev/sda2 not found.
  VG      #PV #LV #SN Attr   VSize  VFree 
  storage   1   0   0 wz--n- <2.00g <2.00g
```
```
[user1@storage ~]$ sudo lvcreate -l 100%FREE storage 
  Logical volume "lvol0" created.
```
```
[user1@storage ~]$ sudo lvs
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBb82e9ad1-30a0508e_ PVID bTTF5ek2AUZ2PZjuz1mLgyDy39lqp5wo last seen on /dev/sda2 not found.
  LV    VG      Attr       LSize  Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  lvol0 storage -wi-a----- <2.00g  
```


🌞 **Formater la partition**
```
[user1@storage ~]$ sudo mkfs -t ext4 /dev/storage/lvol0 
mke2fs 1.46.5 (30-Dec-2021)
Creating filesystem with 523264 4k blocks and 130816 inodes
Filesystem UUID: cd550173-7e60-4676-b44d-7cfd09a1f9b8
Superblock backups stored on blocks: 
	32768, 98304, 163840, 229376, 294912

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done
```

```
[user1@storage ~]$ sudo lvdisplay
  Devices file sys_wwid t10.ATA_____VBOX_HARDDISK___________________________VBb82e9ad1-30a0508e_ PVID bTTF5ek2AUZ2PZjuz1mLgyDy39lqp5wo last seen on /dev/sda2 not found.
  --- Logical volume ---
  LV Path                /dev/storage/lvol0
  LV Name                lvol0
  VG Name                storage
  LV UUID                pCwKSf-3rSZ-3De2-k9X9-Mmd3-n1MT-7EjSWj
  LV Write Access        read/write
  LV Creation host, time storage.tp4.linux, 2022-12-05 18:17:59 +0100
  LV Status              available
  # open                 0
  LV Size                <2.00 GiB
  Current LE             511
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           253:2
```

🌞 **Monter la partition**

```
[user1@storage ~]$ sudo mkdir /mnt/storage
```

```
[user1@storage ~]$ sudo mount /dev/storage/lvol0 /mnt/storage/
```

```
[user1@storage ~]$ df -h | grep storage
/dev/mapper/storage-lvol0  2.0G   24K  1.9G   1% /mnt/storage
```

```
[user1@storage ~]$ sudo touch /mnt/storage/test
[user1@storage ~]$ ls /mnt/storage/
lost+found  test
```

```
[user1@storage ~]$ sudo umount /mnt/storage/
[user1@storage ~]$ sudo mount -av
/                        : ignored
/boot                    : already mounted
none                     : ignored
mount: /mnt/storage does not contain SELinux labels.
       You just mounted a file system that supports labels which does not
       contain labels, onto an SELinux box. It is likely that confined
       applications will generate AVC messages and not be allowed access to
       this file system.  For more details see restorecon(8) and mount(8).
/mnt/storage             : successfully mounted
```