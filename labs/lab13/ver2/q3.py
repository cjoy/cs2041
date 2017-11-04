#!/usr/bin/python3


import sys

if len(sys.argv) == 1:
    exit
else:
    argmap = {}
    for arg in sys.argv[1:]:
        if arg not in argmap:
            argmap[arg] = 1
        else:
            argmap[arg] += 1



    m = list(sorted(argmap))[0]
    v = argmap[m]


    for arg in sorted(argmap):
        if argmap[arg] > v:
            m = arg
            v = argmap[arg]


    print(m)
