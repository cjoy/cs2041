#!/bin/sh

from=$(($1))
to=$(($2))
file=$3

#echo $from to $to into $file

while [ $from -le $to ]
do
	echo $from
	from=$(($from+1))
done > $file

