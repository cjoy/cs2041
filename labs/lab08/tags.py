#!/usr/bin/python

import sys, re, subprocess


if sys.argv[1] == "-f":
	link = sys.argv[2]
else:
	link = sys.argv[1]

htdoc = subprocess.check_output(["wget","-q","-O-",link])
tags = {}

# loop through each tag and add
for t in re.findall( r"<(\w+).*?>" , htdoc ):
	tags[t.lower()] = tags.get(t.lower(),0) + 1

if sys.argv[1] == "-f":
	for t in sorted(tags.items(), key=lambda x: (x[1], x[0]) ):
		print t[0], t[1]
else:
        for t in sorted(tags):
                print t, tags[t]
