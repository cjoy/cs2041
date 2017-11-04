#!/usr/bin/python3

import sys

for line in sys.stdin:
    words = line.split()
    for i in range(len(words)):
        print(words[len(words)-i-1], end=" ")
    print()
