#!/usr/bin/perl

while (($s = <>) =~ /\S/ ) {
	push @lines, $s;
}

foreach $line (@lines) {
	$line =~ s/[0-4]/</g;
	$line =~ s/[6-9]/>/g;
	print "$line"
}
