#!/usr/bin/python3

import sys
import re

word=sys.argv[1].lower()
word = re.sub(r'[^a-zA-Z0-9]', '', word)

pali = True
for i in range(int(len(word)/2)):
	if word[i] != word[len(word)-1-i]:
		pali = False

print(pali)


