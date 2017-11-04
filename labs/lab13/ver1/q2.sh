#!/bin/sh
cat students.txt | grep "|F$" | cut -d\| -f2 | sort
