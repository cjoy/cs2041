#!/usr/bin/python3
# put your demo script here

# Attribution: copied from assignment specs - examples/4/reverse_lines.0.py
# Print line from stdin in reverse order

import sys

lines = []
for line in sys.stdin:
    lines.append(line)
    
i = len(lines) - 1
while i >= 0:
    print(lines[i], end='')
    i = i - 1