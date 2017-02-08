#!/bin/bash

fileName="/data/1/getsys/getsysstat.txt"

while true;do
    CTime=`date +%y-%m-%d:%H:%M:%S`
    echo $CTime >> $fileName
    cat /proc/net/softnet_stat >> $fileName
    sleep 3
    fileSize=`stat -c %s $fileName`
    if [ $fileSize -gt 10000000 ]
    then
        mv $fileName $fileName-`date +%y-%m-%d:%H:%M:%S`
    fi
    find . -name "*.cap*" -a -cmin +1440 |xargs -i rm {}
done
