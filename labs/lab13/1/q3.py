#!/usr/bin/python3
import sys

printed = []
for arg in sys.argv[1:]:
    if arg not in printed:
        print(arg, end=" ")
        printed.append(arg)

print()
