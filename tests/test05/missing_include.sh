#!/bin/bash

for arg in $@; do
	included=`cat $arg | grep '#include' | grep '"' | cut -d' ' -f2 | sed -e 's/"//g'`
	for file in $included; do
		if [ ! -e $file ]; then
			echo $file included into $arg does not exist
		fi
	done
done


#cat a.c | grep '#include' | grep '"' | cut -d' ' -f2 | sed -e 's/"//g'
