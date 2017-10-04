#!/usr/bin/python3
# put your test script here
import sys

lengths = []
for l in sys.stdin:
    lengths.append(len(l) - 1)

for le in lengths:
    print(le)