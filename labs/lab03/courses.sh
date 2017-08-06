#!/bin/sh
undergrad=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=O"|grep OPTM| sed -e 's/<[^>]*>//g' | cat -A | tr -d '^I' | tr -d '$'`

IFS='
'
for u in $undergrad
do
	echo $u
done