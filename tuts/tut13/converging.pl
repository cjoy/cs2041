#!/usr/bin/perl

my @numbers;
while ($line = <STDIN>) {
	chomp $line;
	@nums = split / /, $line;
	for $num (@nums) {
		if ($num =~ /[0-9]/) {
			push @numbers, int($num);
		}
	}
}

$prev = shift(@numbers);
for $num (@numbers) {
	if (defined $diff) {
		if ($prev - $num > $diff) {
			print "not converging\n";
			exit(0);
		}
	}	

	$diff = $prev - $num;

	if ($prev <= $num) {
		print "not converging\n";
		exit(0);
	}

	$prev = $num;
}

print "converging\n";
