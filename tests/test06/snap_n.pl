#!/usr/bin/perl -w

while (<STDIN>) {
	$numLine{$_}++;
	if ($numLine{$_} == $ARGV[0]) {
		print "Snap: $_";
		exit(0);
	}
}
