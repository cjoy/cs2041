#!/bin/sh

if (( $# != 1 )); then
    echo "Invalid usage: ./rmall.sh <directory>"
    exit 1
fi

if [ -e "$1" ]; then
    echo "Delete $1 ?"
    read ans
    if [ $ans = "yes" ]; then
    	rm -r $1
    fi
else
    echo "File doesn't exists"
fi
