#!/usr/bin/python3
# put your demo script here

# hide vowels from arguments

import sys, re
for i in range(1,len(sys.argv)):
    line = re.sub(r'[aeiou]', '*', sys.argv[i])
    print(line, end='')

print()