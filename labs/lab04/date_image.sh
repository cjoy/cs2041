#/bin/sh

PATH=$PATH:.

for arg in "$@"
do
	epoch=`date -R -r "$arg"`
	times=`ls -l "$arg" | cut -d' ' -f6-8`
	ext=`echo "$arg" | cut -d'.' -f2`
	convert -gravity south -pointsize 36 -draw "text 0,10 '$times'" "$arg" temporary_file.$ext
	mv temporary_file.$ext "$arg"
	touch -d "$epoch" "$arg"
done
