#!/bin/sh

for arg in $*
do
	echo -n "Address to e-mail this image to? "
	read email
	echo -n "Message to accompany image? "
	read message
	
	fn=`echo $arg | cut -d'.' -f1`

	echo $message|mutt -s $fn! -e 'set copy=no' -a $arg -- $email

	echo "$arg sent to $email"
done


