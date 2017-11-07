#!/bin/sh

start=$1
end=$2
file=$3

while (($start <= $end))
do

	echo $start
	start=$(($start+1))

done > $file
