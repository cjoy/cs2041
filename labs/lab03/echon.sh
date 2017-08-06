#!/bin/bash
argc=$(($#))
num=$(($1))
word="$2"
if (($argc != 2)) || (($num < 0))  ; then
	echo "Usage: ./echon.sh <number of lines> <string>"
fi

x=0
while (($x < $num))
do
	echo $2
	x=$(($x+1))
done