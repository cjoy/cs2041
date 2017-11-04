#!/usr/bin/python3
import sys
import re
import math

for line in sys.stdin:
    words = line.split()
    for word in words:
        look = re.search(r'(\d+.\d+)',word)
        if look == None:
            print(word, end=" ")
        else:
            num = math.ceil(float(look.group(0)))
            print(num, end=" ")

    print()
