#!/bin/bash

for file in `ls *.htm*`;
do
	fileName=`echo $file | cut -d'.' -f1`
	if [ -e $fileName.html ];
	then
		echo $fileName exists
		exit
	else
		 mv $file $fileName.html
	fi
done
