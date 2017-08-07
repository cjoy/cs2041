#!/bin/bash
wor=`echo $1 | cut -c1`
undergrad=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Undergraduate&descr=$wor"|grep $1| sed -e 's/<[^>]*>//g' | tr -d '\t' | tr -d '$' | egrep -v "Use this search only"`
postgrad=`wget -q -O- "http://www.handbook.unsw.edu.au/vbook2017/brCoursesByAtoZ.jsp?StudyLevel=Postgraduate&descr=$wor"|grep $1| sed -e 's/<[^>]*>//g' | tr -d '\t' | tr -d '$' | egrep -v "Use this search only"`

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

#num_ugrad=`echo -e "$ugrad" | wc -l`
#num_pgrad=`echo -e "$pgrad" | wc -l`
#echo $num_ugrad
#echo $num_pgrad

#if (( $num_ugrad < 1 )) && (( $num_pgrad >= 1 ))
#then
	#echo 'no ugrad but pgrad'
#	allgrad=`echo -e "$pgrad"`
#elif (( $num_ugrad >= 1 )) && (( $num_pgrad < 1 ))
#then
	#echo 'no pgrad but ugrad'
#	allgrad=`echo -e "$ugrad"`
#elif  (( $num_ugrad < 1 )) && (( $num_pgrad < 1 ))
#then
	#echo 'no pgrad and ugrad'
#	allgrad=`echo -e ""`
#else
	#echo 'both pgrad and ugrad'	
#	allgrad=`echo -e "$ugrad\n$pgrad"`
#fi

echo -e "$ugrad\n$pgrad" | sort | uniq | sed -e '/^$/d' | sed 's/\s*$//g' | uniq
