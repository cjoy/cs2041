#!/usr/bin/perl

$find = lc @ARGV[0];
$count = 0;

while ($line = <STDIN>) {
	chomp $line;
	$line = lc $line;
	@words = grep(/./, split(/[^a-zA-Z]/, $line));
	
	# loop through each line and check for the word
	foreach $i (@words) {
		if ($i =~ /^$find$/i) {
			$count++
		}
	}
}

print @ARGV[0], " occurred " , $count, " times\n";
