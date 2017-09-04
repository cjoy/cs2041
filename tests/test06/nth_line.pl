#!/usr/bin/perl

$find_line = $ARGV[0];
$file = $ARGV[1];

open F, $file or die;
$count = 1;
while ($line = <F>) {
	if ($count == $find_line) {
		print $line;
		exit(0);
	}
	$count += 1;
}
