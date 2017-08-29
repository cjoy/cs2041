#!/bin/bash

cat $1 | cut -d'|' -f3 | cut -d',' -f2 | column -t | cut -d' ' -f1 | sort -n | uniq -c | sort -n | tail -1 | column -t | sed -e 's/[0-9]//g' | column -t
