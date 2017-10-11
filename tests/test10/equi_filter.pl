#!/usr/bin/perl
my @lines;

while (<>) {
	chomp;
	push @lines, $_;
}






foreach my $line (@lines) {
	@words = split ' ', $line;
	
	# loop through each word	
	foreach my $word (@words) {
		my %chars;

		@letters = split //, $word;
		# index characters
		foreach my $letter (@letters) { $chars{lc($letter)}++ }
		# delete spaces
		delete $chars{''};
		# set character count standard
		my $val = $chars{(keys %chars)[0]};
		
		# loop through each char and check if it 
		# complies to char count standard
		my $print_word = 1;
		foreach my $char (keys %chars) {
			if ($chars{$char} != $val) {
				$print_word = 0;
			}
		}
	
		if ($print_word == 1) {
			print "$word ";
		}

	}

	
	print "\n";

}
