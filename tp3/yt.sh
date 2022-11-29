#!/bin/bash

-H pip install --upgrade youtube-dl > /dev/null 2> /dev/null

if [[ -d downloads ]]
then
    cd downloads
    name=$(youtube-dl -e ${1})
    name=$(tr -s ' ' '_' <<< $name)
    mkdir $name
    youtube-dl -o $name/$name.mp4 ${1} > fin.txt
    cd $name
    youtube-dl --get-description ${1} > description
    cd ..
    if grep -q 100% fin.txt
    then
        rm fin.txt
        echo "Video ${1} was downloaded."
        echo "File path : /srv/yt/downloads/${name}/${name}.mp4"
        cd ..
        if [[ -d var/log/yt ]]
        then
            cd var/log/yt
            echo "$(date +"%Y-%m-%d %T") Video ${1} was downloaded. File path /srv/yt/downloads/${name}/${name}.mp4" >> download.log
        else
	    exit
        fi  
  fi
else
    exit
fi
