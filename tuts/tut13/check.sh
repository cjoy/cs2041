#!/bin/sh

cut -d' ' -f1 < marks.txt | sort | uniq -c | egrep -v "^ *1 " | column -t | sed -e 's/^.*  //'
