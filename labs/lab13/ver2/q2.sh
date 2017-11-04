#!/bin/sh

cat q2_input.txt | cut -d\| -f2 | sort | uniq -c | egrep "^\s+1" | column -t | tr -d "1  "
