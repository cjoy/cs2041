#!/usr/bin/python3
import sys, re
file = sys.argv[1]

# create set of new lines
F = open(file, "r")
lines = []
for line in F:
    lines.append(re.sub(r"(a|e|i|o|u|A|E|I|O|U)","", line))
F.close

# write these lines to new file
F = open(file, "w")
for line in lines:
    F.write(line)
F.close