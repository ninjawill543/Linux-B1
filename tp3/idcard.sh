#!/bin/bash

test=1
len=$(ss -ltunp | tail -n +2 | wc -l)

echo "Machine name : $(hostnamectl | grep Static | cut -d" " -f4)"
echo "OS $(hostnamectl | grep Operating | cut -d" " -f3) and kernel version is $(uname -r)"
echo "IP : $(ip a | grep "inet " | sed -n 2p | tr -s ' ' | cut -d" " -f3)"
echo "RAM : $(free -h | grep Mem | tr -s ' ' | cut -d" " -f3) memory available on $(free -h | grep Mem | tr -s ' ' | cut -d" " -f2) total memory"
echo "Disque : $(df -h | grep " /$" | tr -s ' '| cut -d" " -f4) space left "
echo "Top 5 processes by RAM usage :"
for i in {2..6}
do
  proc=$(ps aux --sort -rss | sed -n ${i}p| tr -s ' ' |cut -d" " -f11)
  echo "  - ${proc}"
done
echo "Listening ports :"
while [[ ${test} -le ${len} ]]
do
  echo "  - $(ss -ltunp | tail -n +2 | ss -ltunp | tail -n +2 | tr -s ' ' | sed -n ${test}p | tr -s ' ' | cut -d" " -f5 | cut -d":" -f2) $(ss -ltunp | tail -n +2 | ss -ltunp | tail -n +2 | tr -s ' ' | sed -n ${test}p | tr -s ' ' | cut -d" " -f1) : $(ss -ltunp | tail -n +2 | ss -ltunp | tail -n +2 | tr -s ' ' | sed -n ${test}p | tr -s ' ' | cut -d" " -f7 | cut -d'"' -f2 ) "
  test=$(( test + 1 ))
done
curl https://cataas.com/cat --output cat.jpg 2> /dev/null
echo " "
echo "Here is your random cat : ./cat.jpg"
