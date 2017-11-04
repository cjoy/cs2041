#!/bin/sh
cat q2_input.txt | cut -d\| -f2 | sort | uniq -c | grep "1 " | column -t | sed -e s/"^1  "//g
