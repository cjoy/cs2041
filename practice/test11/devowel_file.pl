#!/usr/bin/perl


$fn = $ARGV[0];
open my $file, "<", $fn or die "Couldn't open file";
my $nlines = '';
while ($line = <$file>) {
	$line =~ s/[a|e|i|o|u|A|E|I|O|U]//g;
	$nlines .= $line;
}
close $file;

open my $file, ">", $fn or die "Couldn't open file";
print $file $nlines;
close $file;

