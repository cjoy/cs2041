#!/bin/sh

while read input
do
	output=`echo $input | tr [0-4] '<' | tr [6-9] '>'`
	echo $output
done
