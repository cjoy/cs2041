#!/usr/bin/python3

import sys


for line in sys.stdin:
    words = sorted(line.split())
    for word in words:
        print(word, end=" ")
    print()
