#!/usr/bin/python3

import sys
import re

lett_map = {}
for line in sys.stdin:
    line = re.sub(r'[^a-zA-Z0-9]','',line)
    for letter in line:
        if letter not in lett_map:
            lett_map[letter] = 1
        else:
            lett_map[letter] += 1


for letter in sorted(lett_map):
    print("'"+letter+"' occured", lett_map[letter], "times")
