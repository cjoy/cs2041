#!/usr/bin/perl

# count words in a file
sub countWords {
	my ($find, $file) = @_;
	$count = 0;	
	open F, $file or die;
        while ($line = <F>) {
                chomp $line;
		$line = lc $line;
                @words = grep(/./, split(/[^a-zA-Z]/, $line));
		# loop through each line and check for the word
        	foreach $i (@words) {
                	if ($i =~ /^$find$/i) {
                        	$count++;
                	}
        	}
        }
	return $count;
}


# counts total words in a file
sub totalWords {
	my ($file) = @_;
	open F, $file or die;
	$count = 0;
	while ($line = <F>) {
		chomp $line;
		@words = grep(/./, split(/[^a-zA-Z]/, $line));
		$count += 0+@words;
	}
	return $count;
}

foreach $file (glob "lyrics/*.txt") {	
	$cw = countWords(@ARGV[0], $file);
	$ncw = $cw + 1;
	$tw = totalWords($file);
	$fq = log($ncw/$tw);
	# get artist name
	@fn = split("/", $file);
	@ufn = split(".txt", @fn[1]);
	$artist = @ufn[0];
	$artist =~ s/_/ /g;
	
	printf("log((%d+1)/%6d) = %8.4f %s\n", $cw, $tw, $fq, $artist);
	
}
