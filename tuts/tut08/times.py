#!/usr/bin/python3

import sys

rows = int(sys.argv[1])
cols = int(sys.argv[2])
width = int(sys.argv[3])-1

for y in range(1,rows+1):
    for x in range(1,cols+1):
        mul = x*y
        wid = width-len(str(mul))
        print(" "*wid, mul, end="")
    print()
