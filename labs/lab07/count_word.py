#!/usr/bin/python

import sys
import re

words = []

# loop through stdin
for lines in sys.stdin:
	words += re.split(r'[^a-zA-Z]', lines.lower());


words = filter(None, words)

count = 0;
for w in words:
	if w == sys.argv[1]:
		count += 1
		

# print output
print sys.argv[1] + " occurred " + str(count) + " times";
