#!/usr/bin/env python
#coding=utf8

import datetime
import time
from datetime import date
import urllib2
import os
import sys
from bs4 import BeautifulSoup


def gettasklist(url):
    req = urllib2.Request(url)
    response = urllib2.urlopen(req)
    data = response.read()
   # print data
    file_object = open('temp.txt','w')
    try:
        file_object.write(data)
    finally:
        file_object.close()
    
    tasklist = []
    file_object = open('temp.txt')
    templine = file_object.readline()
    lines = file_object.readlines()
    for line in lines:
        line=line.strip('\n')
        line=line.strip('\r')
        tasklist.append(line.split(','))
    file_object.close()
    return tasklist

def taskipdomain(taskls):
    currenttime = datetime.datetime.now()
    minutes30 = datetime.timedelta(minutes=30)
    starttime = currenttime - minutes30
    currenttime_str_ymd = currenttime.strftime('%Y-%m-%d')
    starttime_str_ymd = starttime.strftime('%Y-%m-%d')
    currenttime_str_hm = currenttime.strftime('%H:%M')
    starttime_str_hm = starttime.strftime('%H:%M')

    
    taskreturn = []
    for index in range(len(taskls)):
        taskcontent = []
        currenttask = taskls.pop()
        taskcontent.append(currenttask[0])
        taskcontent.append(currenttask[1])
        taskcontent.append(currenttask[5])
        taskurl = "http://dfeed.networkbench.com/rpc-export/exportTxt.po?authkey=Ciw7wP58Aw&taskType=0&taskId="+currenttask[0]+"&startDate=" + starttime_str_ymd + "%20" + starttime_str_hm + "&endDate=" + currenttime_str_ymd + "%20" + currenttime_str_hm   

        req = urllib2.Request(taskurl)
        response = urllib2.urlopen(req)
        data = response.read()
        file_object = open('ipdomain.txt','w')
        try:
            file_object.write(data)
        finally:
            file_object.close()
        
        file_object = open('ipdomain.txt')
        titleline = file_object.readline()
        lines = file_object.readlines()
        for line in lines:
            line = line.strip('\n')
            line = line.strip('\r')
            taskcontent.append(line.split(','))
        file_object.close()

        taskreturn.append(taskcontent)
        #print taskcontent
    return taskreturn 

def iscorrect(task):
    errorcount = 0
    checkip = []
    taskname = ['appapi.yongche.com','chongfan.yongche.com','dmarket.yongche.com','driver-api.yongche.com','message.yongche.com','yop.yongche.com','pay.yongche.com']
    for index in range(len(task)):
        current = task.pop()
        if current[1] not in taskname:
            continue
        #print current
        for index2 in range(len(current)-3):
            taskresult = current.pop()
            checkip.append(taskresult[len(taskresult)-9])
           # print taskresult[len(taskresult)-9]
   # print checkip
    for index3 in range(len(checkip)):
        ipbit = checkip.pop().lstrip("\"").rstrip("\"").split(".")
    #    print ipbit
     #   print "####################"
      #  print "####################"
       # print "####################"
        if ipbit[0] != '124' or ipbit[1] != '250' or ipbit[2] != '26' :
            errorcount = errorcount + 1
    return errorcount

if __name__ == "__main__":
    taskls = gettasklist("http://dfeed.networkbench.com/rpc-export/exportTaskList.po?authkey=Ciw7wP58Aw&status=1&expire=1")
    taskreturn = taskipdomain(taskls)
    errorcounter = iscorrect(taskreturn)
    print errorcounter
