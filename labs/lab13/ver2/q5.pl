#!/usr/bin/perl


while ($line = <STDIN>) {
	chomp $line;
	$line =~ s/\<!(.*)\>/`$1`/g;

	print `echo $line`
}
