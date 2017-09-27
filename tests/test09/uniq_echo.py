#!/usr/bin/python3
import sys

uniq = []
for arg in sys.argv[1:]:
	if arg not in uniq:
		uniq.append(arg)
		print(arg, end=" ")

print()