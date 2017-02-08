#!/bin/bash
ps -ef | grep "/usr/libexec/systemtap" | awk '{print $2}' | xargs -i  kill -9 {}
stap -d bnx2x -v /home/jinzhiyuan/retrans.stp > /home/jinzhiyuan/getretran`date +%y%m%d%H%M`
