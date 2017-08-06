#!/bin/sh
read input
output=`echo $input | tr [0-4] '<' | tr [6-9] '>'`
echo $output