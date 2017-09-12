#!/usr/bin/python

import sys
import re

words = []

# loop through stdin
for lines in sys.stdin:
	words += re.split(r'[^a-zA-Z]', lines);

#filder words
words = filter(None, words);
# print output
print str(len(words)) + " words";
