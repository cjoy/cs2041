#!/usr/bin/perl

while ($line = <STDIN>) {
	chomp $line;
	@words = split / /, $line;
	@words = reverse @words;
	for $word (@words) {
		print "$word ";
	}
	print "\n";
}
