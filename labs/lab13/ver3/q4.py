#!/usr/bin/python3

import sys

for line in sys.stdin:
    c = line.split('|')
    n = c[2]
    ns = n.split(', ')
    print(c[0] + '|' + c[1] + '|' + ns[1] + " " + ns[0] + '|' + c[3] + '|' + c[4], end='')
