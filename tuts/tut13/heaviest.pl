#!/usr/bin/perl


my %numbers;
my $last;
for $arg (@ARGV) {
	if (exists $numbers{$arg}) {
		$numbers{$arg} += 1;
	} else {
		$numbers{$arg} = 1;
	}

	$last = $arg;
}

$max = $numbers{$last};
$maxW = 0;
for $num (keys %numbers) {
	if ($num*$numbers{$num} > $maxW) {
		$maxW = $num*$numbers{$num};
		$max = $num;
	}
}

print "$max\n";
