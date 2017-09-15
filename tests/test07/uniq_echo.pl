#!/usr/bin/perl

use List::MoreUtils qw(uniq);

@uarg = @ARGV;
@uarg = uniq @ARGV;
foreach my $arg (@uarg) {
	print $arg, " ";
}
print "\n";
