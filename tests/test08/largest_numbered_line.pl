#!/usr/bin/perl



my $mN;
my $mL;

while ($line = <STDIN>) {
	chomp $line;

	@numbers = $line =~ /[-+]?[0-9]*\.?[0-9]+/g;
	foreach $n (@numbers) {
		if (!$mN) {
			$mN = $n;
			$mL = "$line\n";
		} elsif ($mN < $n) {
			$mN = $n;
			$mL = "$line\n";
		} elsif ($mN == $n) {
			$mL .= "$line\n";
		}
	}

}


print "$mL";

