#!/usr/bin/perl
use List::MoreUtils qw(uniq);

my $needLines = $ARGV[0];
my @myLines;

my $readLines = 0;
my $notLines = 0;
while ( ($line = <STDIN>) =~ /\S/) {
	
	if ($readLines < $needLines) {
	chomp $line;
	$line = lc $line;
	$line =~ s/\s+/ /g;
	$line =~ s/^\s//g;
	$line =~ s/\s$//g;
	push @myLines, $line;
	$readLines++;
	} else {
	$notLines++;
	}



}
@myLines = uniq @myLines;
my $uniqLines = @myLines + 0;
my $totLines = $readLines + $notLines;

if ($readLines >= $needLines and $notLines < $totLines) {
	print $uniqLines, " distinct lines seen after ", $readLines, " lines read.\n";
}
