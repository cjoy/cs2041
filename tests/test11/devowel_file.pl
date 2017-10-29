#!/usr/bin/perl
my $file = $ARGV[0];

my $lines;
while (<>) {
    $_ =~ s/(a|e|i|o|u|A|E|I|O|U)//g;
    $lines .= $_;
}

open $outfile, '>', $file or die "Can't open file";
print $outfile $lines;
close F;