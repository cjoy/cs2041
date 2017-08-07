#!/bin/bash
wor=`echo $1 | cut -c1`
undergrad=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=$wor"|grep $1| sed -e 's/<[^>]*>//g' | cat -A | tr -d '^I' | tr -d '$' | egrep -v "Use this search only if you have an exact code for a Program"`
postgrad=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=$wor"|grep $1| sed -e 's/<[^>]*>//g' | cat -A | tr -d '^I' | tr -d '$' | egrep -v "Use this search only if you have an exact code for a Program"`

IFS='
'
count=1
for u in $undergrad
do
	if (( $count % 2 == 0 ))
	then
		ugrad+=" $u"
	else
		if (($count == 1))
		then
			ugrad+="$u"
		else
			ugrad+="\n$u"
		fi
	fi
	count=$(($count+1))
done

count=1
for u in $postgrad
do
	if (( $count % 2 == 0 ))
	then
		pgrad+=" $u"
	else
		if (($count == 1))
		then
			pgrad+="$u"
		else
			pgrad+="\n$u"
		fi
	fi
	count=$(($count+1))
done

allgrad=$ugrad$pgrad
echo -e "$allgrad" | sort | uniq | sort -n
