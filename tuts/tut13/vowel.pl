#!/usr/bin/perl

while ($line = <STDIN>) {
	chomp $line;
	@letters = split //, $line;
	for $l (@letters) {
		if ($l =~ /(A|E|I|O|U)/) {
			print(lc($l));
		} elsif ($l =~ /(a|e|i|o|u)/) {
			print(uc($l));		
		} else {
			print($l);
		}
	}
	print "\n";
}
