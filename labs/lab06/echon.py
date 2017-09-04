#!/usr/bin/python3

import sys

if len(sys.argv) != 3:
	print("Usage: ./echon.py <number of lines> <string>")
	exit(1)

if not sys.argv[1].isdigit():
	print("./echon.py: argument 1 must be a non-negative integer")
	exit(1)

print((sys.argv[2]+"\n")*int(sys.argv[1]), end="")
