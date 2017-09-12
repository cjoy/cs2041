#!/usr/bin/perl

while (($line = <STDIN>) =~ /\S/ ) {
	$line =~ s/[0-9]+//g;
	push @lines, $line;
}

foreach $line (@lines) {
	print $line;
}
