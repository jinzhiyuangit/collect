#!/usr/bin/env python
# coding: utf-8

import os
import sys
import subprocess
import re

NODE_BASE_PATH = '/sys/devices/system/node/'

node_map = {}

# find processors on the same node
for p in os.walk(NODE_BASE_PATH):
    node_list = filter(lambda x: x.startswith("node"), p[1])

    for node in node_list:
        dirpath = os.path.join(p[0], node)
        # /sys/devices/system/node/node0/cpulist
        _f = open(os.path.join(dirpath, "cpulist"), "r").readline()
        node = dirpath.split("/")[-1]
        # find cores on the same node
        node_map[node] = {}
        node_map[node]['nodes'] = _f.strip("\n").split(",")
    break

# find processors which share the same index0 cache
for k, v in node_map.iteritems():
    node_map[k]['siblings'] = []
    for processor in v['nodes']:
        shared_list = os.path.join("/sys/devices/system/node/", k, 'cpu%s' % processor, "cache/index0/shared_cpu_list")
        _f = open(shared_list, "r").readline()
        siblings = _f[:-1].split(",")
        if siblings not in node_map[k]['siblings']:
            node_map[k]['siblings'].append(siblings)

#print node_map

# determine the irq or interfaces
if len(sys.argv) <= 1:
    print "Need to specify an interface"
    sys.exit(1)

INF = sys.argv[1]

if not INF:
    sys.exit(1)
else:
    if not re.match("^em|eth|^p", INF):
        sys.exit(2)

grep = "egrep %s /proc/interrupts | awk -F':' '{print $1}'" % INF
p = subprocess.Popen(grep, stderr=subprocess.PIPE, stdout=subprocess.PIPE, shell=True)
out, err = p.communicate()

irq_list = [ line.strip() for line in out.splitlines() ]

if len(irq_list) == 0:
    print "Cant't find interface %s and its irq" % INF

# calculate affinity mask
if 'node1' in node_map:
    target_node = 'node1'
else:
    target_node = 'node0'

for irq in irq_list:
    idx = irq_list.index(irq)
    cores = node_map[target_node]['siblings'][idx]
    mask = bin(1<<int(cores[0]))
    affinity = hex(int(mask, 2))[2:]
    affinity_file = os.path.join("/proc/irq", irq, "smp_affinity")
    print "Set irq: %s affinity to %s" % (irq, affinity)
    _f = open(affinity_file, "w")
    _f.write(affinity+"\n")
    _f.close()
