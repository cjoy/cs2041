#!/usr/bin/python3

import sys
import os
import re


def getFile(line):
    f = re.search(r'#include "(.*)"', line).group(1)
    return f

def printFile(fn):
    print(fn)
    for l in open(fn).readlines():
        if "#include" in l:
            printFile(getFile(l))
        else:
            print(l, end="")
    
    
    return
    
for l in open(sys.argv[1]).readlines():
    if "#include" in l:
        printFile(getFile(l))
    else:
        print(l, end="")
