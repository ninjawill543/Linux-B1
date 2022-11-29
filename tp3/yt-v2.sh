#!/bin/bash

-H pip install --upgrade youtube-dl > /dev/null 2> /dev/null

while :
do
    cd ~/Downloads
    url=$(head -n 1 url.txt)
    youtube-dl -e {url} < hold.txt
    if ! grep -q ERROR hold.txt
    then
        rm hold.txt
        sed -i '1d' url.txt 
        name=$(youtube-dl -e ${url})
        name=$(tr -s ' ' '_' <<< $name)
        mkdir $name
        youtube-dl -o $name/$name.mp4 ${url}
        cd $name
        youtube-dl --get-description ${url} > description
        sleep 5
    fi
done
