#!/usr/bin/perl

$total_words = 0;
while ( ($line = <STDIN>) ) {
      	chomp $line;
	@words = grep(/./, split(/[^a-zA-Z]/, $line));
	$total_words += 0+@words;
}

print $total_words, " words\n";
