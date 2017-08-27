#!/usr/bin/perl -w

#print "$ARGV[1]";

if (@ARGV != 2) {
	print "Usage: ./echon.pl <number of lines> <string>\n";
	exit;
} elsif ($ARGV[0] !~ /^\d+$/) {
	print "./echon.pl: argument 1 must be a non-negative integer\n";
	exit;
}

$i=0;
while ($i < $ARGV[0]) {
	print "$ARGV[1]\n";
	$i++;
}
