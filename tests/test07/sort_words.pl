#!/usr/bin/perl

my @fline;
while ( ($line = <STDIN>) =~ /\S/ ) {
	chomp $line;
	@words = split /\s+/, $line;
	@words = sort @words;
	foreach my $w (@words) {
		print $w, " ";
	}
	print "\n";
}
