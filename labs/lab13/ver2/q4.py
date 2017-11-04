#!/usr/bin/python3

import sys


for line in sys.stdin:
    c = line.split()
    t = c[3]

    ts = t.split(':')
    h = nh = int(ts[0])
    hz = 'pm'
    if h == 0:
        nh = 12
        hz = 'am'
    if h < 12:
        hz = 'am'        
    if h > 12:
        nh -= 12
        hz = 'pm'

    if nh < 10:
        nh = '0'+str(nh)

    d = int(c[2])
    if d < 10:
        c[2] = ' ' + c[2]
    elif d < 100:
        c[2] = '' + c[2]
    
    print(c[0], c[1], c[2], str(nh)+":"+ts[1]+":"+ts[2]+hz, c[4], c[5])   
    
