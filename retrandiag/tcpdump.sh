#!/bin/bash

fileName="/data/1/tcpdump.cap"

while true;do
    CTime=`date +%y-%m-%d:%H:%M`
    tcpdump -n -i bond0 host 172.17.1.93 or host 172.17.10.49 or host 172.17.1.91 -w $fileName -c 100000 && mv $fileName $fileName-$CTime
    find . -name "*.cap*" -a -cmin +1440 |xargs -i rm {}
done
