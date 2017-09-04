#!/usr/bin/python3

from re import sub
import sys


for line in sys.stdin:
	line = sub("[6-9]", ">", line)
	line = sub("[0-4]", "<", line)
	print(line,end="")
