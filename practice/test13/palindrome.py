#!/usr/bin/python3


import sys
import math
import re

word = sys.argv[1]
word = word.lower()
word = re.sub(r'[^a-z]', '', word)

l = math.floor(len(word)/2)

status = True
for i in range(l):
    if word[i] != word[len(word)-i-1]:
        status = False


print(status)
