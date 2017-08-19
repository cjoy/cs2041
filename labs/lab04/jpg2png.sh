#!/bin/sh

for file in *
do
	ext=`echo $file | cut -d'.' -f2`
	fn=`echo $file | cut -d'.' -f1`

	if [ "$ext" == "jpg" ]; then
		if [ ! -f "$fn.png" ]; then
			convert "$fn.$ext" "$fn.png"
			rm "$fn.$ext"
		else
			echo "$fn.png already exists"
		fi
	fi
done

