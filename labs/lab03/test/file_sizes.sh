for f in `ls`
do
	num_lines=$((`wc -l $f | cut -d' ' -f1`))
	if (($num_lines < 10)) ; then
		small_files+=' '$f
	elif (($num_lines < 100)) ; then
		medium_files+=' '$f
	else
		large_files+=' '$f
	fi
done

echo Small files: $small_files
echo Medium-sized files: $medium_files
echo Large files: $large_files