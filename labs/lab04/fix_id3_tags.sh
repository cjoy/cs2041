#!/bin/bash

#set -x

for arg in "$@"
do
	for file in "$arg"/*
	do
		file=`echo "$file" | sed 's/\/\//\//g'`
		track=`echo "$file"  | awk -F" - " '{print $1}' | cut -d',' -f2 | cut -d'/' -f2`
		album=`echo "$file" | cut -d'-' -f1 | cut -d'/' -f2`
		title=`echo "$file" | awk -F" - " '{print $2}'`
		artist=`echo "$file" | awk -F" - " '{print $3}' | sed 's/.mp3//g'`
		year=`echo "$album" | cut -d',' -f2 | column -t`
		id3 -t "$title" "$file" > /dev/null 2>&1
		id3 -a "$artist" "$file" > /dev/null 2>&1
		id3 -A "$album" "$file" > /dev/null 2>&1
		id3 -y "$year" "$file" > /dev/null 2>&1
		id3 -T "$track" "$file" > /dev/null 2>&1

	done

done
