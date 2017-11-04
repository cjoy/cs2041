#!/usr/bin/perl

my %lett_map;
while ($line = <STDIN>) {
	chomp $line;
	$line =~ s/[^a-zA-Z0-9]//g;	
	@letters = split //, $line;
	for $letter (@letters) {
		if (exists $lett_map{$letter}) {
			$lett_map{$letter} += 1;					
		} else {		
			$lett_map{$letter} = 1;					
		}

	}
}

for $l (sort(keys %lett_map)) {
	print "'$l' has occured $lett_map{$l} times\n"
}
