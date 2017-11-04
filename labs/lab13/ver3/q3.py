#!/usr/bin/python3
import sys
import re

fname = sys.argv[1]
query = sys.argv[2]

file = open(fname, 'r')
for line in file:
    nline = re.sub(query,'('+query+')',line)
    if query in line:
        print(nline, end="")

file.close()
