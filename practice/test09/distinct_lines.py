#!/usr/bin/python3
import sys
import re

need = int(sys.argv[1])
dist = []

rl = 0
for line in sys.stdin:
    line = line.lower()
    words = line.split()
    nline = " ".join(words)
    if nline not in dist:
        dist.append(nline)

    rl += 1


if rl >= need:
    print(len(dist), "distinct lines seen after", rl, "lines read.")
else:
    print("End of input reached after", rl, "lines read -", need, "different lines not seen.")
