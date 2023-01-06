#!/bin/bash

# This script was written by Lucas Hanson on the 6th of January 2023.
# The script backs up the most important files of the nextcloud folder by archiving the themes, data and config files, and placing the backup in the /srv/backup folder

[[ -d /srv/backup ]] || mkdir /srv/backup
dnf install tar -y
cd /var/www/tp5_nextcloud/
tar -czf /srv/backup/nextcloud_$( date '+%Y-%m-%d_%H-%M-%S' ).tar.gz themes/ data/ config/
