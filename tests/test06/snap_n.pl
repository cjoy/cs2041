#!/usr/bin/perl -w

while ((my $line = <STDIN>) =~ /\S/ ) {
	$numLine{$line}++;
	if ($numLine{$line} == $ARGV[0]) {
		print "Snap: $line";
		exit(0);
	}
}