#!/usr/bin/perl
my @numbers = sort { $a <=> $b } @ARGV;
$middle = int (@ARGV)/2;
print "$numbers[$middle]\n";