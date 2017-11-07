#!/usr/bin/python3

import sys

args = []
for arg in sys.argv[1:]:
    if arg not in args:
        args.append(arg)
        print(arg, end=" ")

print()

