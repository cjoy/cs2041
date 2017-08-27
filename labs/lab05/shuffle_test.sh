#!/bin/bash
tests=100
file=$1

j=0
while [ $j -lt $tests ]; do

	rn=$((1 + RANDOM % $tests))
	out=`i=0;while [ $i -lt $rn ]; do echo $i; i=$(($i + 1)); done|./$file`
	out2=`echo $out | sed 's/      //'`
	echo "Testing a set with $rn lines:"
	echo $out
	echo $out2
	echo "test passed!"

	j=$((j+1))
done
