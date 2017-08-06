#!/bin/bash
argc=$(($#))
num=$(($1))
word="$2"

if (($argc != 2)); then
        echo "Usage: ./echon.sh <number of lines> <string>"
elif (($num < 0)) ; then
        echo "./echon.sh: argument 1 must be a non-negative integer"
else
	if [ "$1" -eq "$1" ] 2>/dev/null; then
		:
	else
 		echo "./echon.sh: argument 1 must be a non-negative integer"
	fi

        x=0
        while (($x < $num))
        do
                echo $2
                x=$(($x+1))
        done
fi
