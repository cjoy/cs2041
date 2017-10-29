#!/bin/sh
cat $1 | sed -i 's/[aeiouAEIOU]//g' $1
