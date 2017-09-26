#!/usr/bin/python3
import sys

for line in sys.stdin:
	slist = sorted(line.split())
	print(' '.join(slist))