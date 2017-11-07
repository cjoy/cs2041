#!/usr/bin/perl

my @numbers;

while ($line = <STDIN>) {
	@nums = split /\s+/, $line;

	for $n (@nums) {
		if ($n =~ /\d+/) {		
			push @numbers, $n;
		}
	}

}

my %div;
for $n (@numbers) {
	for $m (@numbers) {
		if ($n != $m && ($n%$m) == 0) {
			$div{$n} = 1;
		}
	}
}


for $n (@numbers) {
	if ($div{$n} != 1) {
		print "$n ";
	}
}
print"\n";
