#!/usr/bin/python3

import sys
import re

lines = []
for l in sys.stdin:
    lines.append(l)

for line in lines:
    look = re.search(r'^#(\d+)', line)
    if look == None:    
        print(line, end="")
    else:
        num = look.group(0).split('#')[1]
        print(lines[int(num)-1], end="")
