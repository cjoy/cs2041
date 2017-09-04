#!/bin/bash

IFS='
'
files=`ls -d *.htm`
for file in $files;
do
	fileName=`echo $file | sed -e 's/.htm//g'`
	if [ ! -e "$fileName.html" ]; then
		mv "$file" "$fileName.html"
	else
		echo $fileName.html exists
		exit 1
	fi
done
