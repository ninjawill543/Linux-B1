# TP 3 : We do a little scripting

## Rendu

📁 **Fichier `/srv/idcard/idcard.sh`**

```
m4ul@thinkpad:~/Documents/ynov/linuxb1/tp3$ sudo ./idcard.sh 
Machine name : thinkpad
OS Ubuntu and kernel version is 5.15.0-53-generic
IP : 10.33.19.120/22
RAM : 2,6Gi memory available on 15Gi total memory
Disque : 294G space left 
Top 5 processes by RAM usage :
  - /snap/firefox/2088/usr/lib/firefox/firefox
  - /snap/firefox/2088/usr/lib/firefox/firefox
  - /usr/bin/gnome-shell
  - /snap/code/113/usr/share/code/code
  - /snap/firefox/2088/usr/lib/firefox/firefox
Listening ports :
  - 53 udp : dnsmasq 
  - 53 udp : systemd-resolve 
  - 67 udp : dnsmasq 
  - 53 tcp : dnsmasq 
  - 53 tcp : systemd-resolve 
 
Here is your random cat : ./cat.jpg
```


## Rendu

📁 **Le script `/srv/yt/yt.sh`**

📁 **Le fichier de log `/var/log/yt/download.log`**, avec au moins quelques lignes

```
m4ul@thinkpad:~/Documents/ynov/linuxb1/tp3/srv/yt$ sudo ./yt.sh https://www.youtube.com/watch?v=jNQXAC9IVRw
Video https://www.youtube.com/watch?v=jNQXAC9IVRw was downloaded.
File path : /srv/yt/downloads/Me_at_the_zoo/Me_at_the_zoo.mp4
```


## Rendu

📁 **Le script `/srv/yt/yt-v2.sh`**

📁 **Fichier `/etc/systemd/system/yt.service`**

```
m4ul@thinkpad:~$ systemctl status yt
● yt.service - Youtube video downloader
     Loaded: loaded (/etc/systemd/system/yt.service; disabled; vendor preset: enabled)
     Active: active (running) since Tue 2022-11-29 16:56:38 CET; 1s ago
   Main PID: 21842 (yt-v2.sh)
      Tasks: 2 (limit: 18702)
     Memory: 564.0K
        CPU: 573ms
     CGroup: /system.slice/yt.service
             ├─21842 /bin/bash /home/m4ul/Documents/ynov/linuxb1/tp3/srv/yt/yt-v2.sh
             └─21861 sleep 5

nov. 29 16:56:39 thinkpad yt-v2.sh[21849]: youtube-dl: error: You must provide at least one URL.
nov. 29 16:56:39 thinkpad yt-v2.sh[21849]: Type youtube-dl --help to see a list of all options.
nov. 29 16:56:39 thinkpad yt-v2.sh[21858]: mkdir: missing operand
nov. 29 16:56:39 thinkpad yt-v2.sh[21858]: Try 'mkdir --help' for more information.
nov. 29 16:56:39 thinkpad yt-v2.sh[21859]: Usage: youtube-dl [OPTIONS] URL [URL...]
nov. 29 16:56:39 thinkpad yt-v2.sh[21859]: youtube-dl: error: You must provide at least one URL.
nov. 29 16:56:39 thinkpad yt-v2.sh[21859]: Type youtube-dl --help to see a list of all options.
nov. 29 16:56:39 thinkpad yt-v2.sh[21860]: Usage: youtube-dl [OPTIONS] URL [URL...]
nov. 29 16:56:39 thinkpad yt-v2.sh[21860]: youtube-dl: error: You must provide at least one URL.
nov. 29 16:56:39 thinkpad yt-v2.sh[21860]: Type youtube-dl --help to see a list of all options.
```

```
m4ul@thinkpad:~$ journalctl -xe -u yt
nov. 29 16:56:44 thinkpad yt-v2.sh[21870]: rm: cannot remove 'hold.txt': No such file or directory
nov. 29 16:56:44 thinkpad yt-v2.sh[21872]: Usage: youtube-dl [OPTIONS] URL [URL...]
nov. 29 16:56:44 thinkpad yt-v2.sh[21872]: youtube-dl: error: You must provide at least one URL.
nov. 29 16:56:44 thinkpad yt-v2.sh[21872]: Type youtube-dl --help to see a list of all options.
nov. 29 16:56:44 thinkpad yt-v2.sh[21875]: mkdir: missing operand
nov. 29 16:56:44 thinkpad yt-v2.sh[21875]: Try 'mkdir --help' for more information.
nov. 29 16:56:44 thinkpad yt-v2.sh[21876]: Usage: youtube-dl [OPTIONS] URL [URL...]
nov. 29 16:56:44 thinkpad yt-v2.sh[21876]: youtube-dl: error: You must provide at least one URL.
nov. 29 16:56:44 thinkpad yt-v2.sh[21876]: Type youtube-dl --help to see a list of all options.
nov. 29 16:56:44 thinkpad yt-v2.sh[21877]: Usage: youtube-dl [OPTIONS] URL [URL...]
nov. 29 16:56:44 thinkpad yt-v2.sh[21877]: youtube-dl: error: You must provide at least one URL.
nov. 29 16:56:44 thinkpad yt-v2.sh[21877]: Type youtube-dl --help to see a list of all options.
nov. 29 16:56:49 thinkpad yt-v2.sh[21883]: /home/m4ul/Documents/ynov/linuxb1/tp3/srv/yt/yt-v2.sh: li>
nov. 29 16:56:49 thinkpad yt-v2.sh[21884]: grep: hold.txt: No such file or directory
nov. 29 16:56:49 thinkpad yt-v2.sh[21885]: rm: cannot remove 'hold.txt': No such file or directory
nov. 29 16:56:50 thinkpad yt-v2.sh[21887]: Usage: youtube-dl [OPTIONS] URL [URL...]
```


