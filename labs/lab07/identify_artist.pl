#!/usr/bin/perl


# init hashmaps
my %artistFiles;
my %totalWords;
foreach $file (glob "lyrics/*.txt") {
	open F, "$file" or die;
	while ($line = <F>) {
		chomp $line;
                $line = lc $line;
                @words = grep(/./, split(/[^a-zA-Z]/, $line));
                # loop through each line and check for the word
               	foreach $i (@words) {
			# bag of words
                	if (!$artistFiles{$file}{$i}) {
				$artistFiles{$file}{$i} = 1;
			} else {
				$artistFiles{$file}{$i}++;
			}
			# total words hash
			if (!$totalWords{$file}) {
				$totalWords{$file} = 1;
			} else {
				$totalWords{$file}++;
			}
        	}
	}
}


# set the log prob of each artist into a hashmap
sub logProb {
	my ($find) = @_;
	foreach $file (glob "lyrics/*.txt") {	
		$cw = $artistFiles{$file}{$find};
		$ncw = $cw + 1;
		$tw = $totalWords{$file};
		$fq = log($ncw/$tw);
		# get artist name
		@fn = split("/", $file);
		@ufn = split(".txt", @fn[1]);
		$artist = @ufn[0];
		$artist =~ s/_/ /g;

		$prob{$artist} = $fq;
	}
	return %prob;
}


sub getSongWords {
	my ($file) = @_;
	my %songWords;
	open F, $file or die;
	while ($line = <F>) {
                chomp $line;
                $line = lc $line;
                @words = grep(/./, split(/[^a-zA-Z]/, $line));
                # loop through each line and check for the word
                foreach $i (@words) {
			if (!$songWords{$i}) {
				$songWords{$i} = 1;
			} else {
				$songWords{$i}++;
			}
         	}
	}
	
	return %songWords;
}


my %singer;
for my $arg (@ARGV) {
	my %songWords = getSongWords($arg);

	foreach my $word (keys %songWords) {
		my %wordProb = logProb($word);
		# expand log prob and get artists
		foreach my $artist (keys %wordProb) {
			$singer{$artist} += $wordProb{$artist} * $songWords{$word};
		}
	}

	my $mN = "Adele"; my $mV = $singer{"Adele"};   
	foreach my $sign (keys %singer) {
		if ($mV < $singer{$sign}) {
			$mV = $singer{$sign};
			$mN = $sign;
		}
	}
	
	printf("$arg most resembles the work of $mN (log-probability=%4.1f)\n", $singer{$mN});
	
	undef %songWords;
	undef %singer;
}
