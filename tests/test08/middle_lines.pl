#!/usr/bin/perl

open F, $ARGV[0] or die;

my @text;
while ($line = <F>) {
	chomp $line;
	push @text, $line;
}

$num = scalar @text;

if ($num == 0) {
	
} elsif ($num%2 != 0) {
	$middle = $num/2;
	print $text[$middle], "\n";
} else {
	$middle = $num/2 - 0.5;
	print $text[$middle],"\n";
	print $text[$middle+1],"\n";
}
