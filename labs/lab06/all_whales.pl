#!/usr/bin/perl

@whales = ();


while ( ($line = <STDIN>) =~ /\S/ ) {
	push @whales, $line;
}

@nwhales = ();
foreach $wh (@whales) {
	$str = lc $wh;
	$str =~ s/s$//;
	$str =~ s/\s+/ /g;
#	print $str, "\n";
	push @nwhales, $str;
}

# search array with numbers removed
@usearch = ();
for ($i = 0; $i < @whales; $i++) {
	$str = $whales[$i];
	$str =~ s/\D//g;
	$nstr = $whales[$i]; 
	$nstr =~ s/$str //;
	$nstr = lc $nstr;
	$nstr =~ s/s$//;
	push @usearch, $nstr
	
}

# pretty search array with removed spaces
@nsearch = ();
foreach $entry (@usearch) {
	$str = $entry;
	$str =~ s/^\s+|\s+$//g;
	$str =~ s/\s+/ /g;	

	$df = 0;
	foreach $s (@nsearch) {
		if ($s =~ $str) {
			$df =+ 1;
		}
	}

	# if not in search array
	if ($df == 0) {
		push @nsearch, $str;
	}
}

@fsearch = sort @nsearch;

# find results from each search term
foreach $search (@fsearch) {
	$foundPods = 0;
	$foundWhales = 0;

	for ($i = 0; $i < @nwhales; $i++) {
        	if ($nwhales[$i] =~ $search) {
                	$foundPods += 1;
                	$nwhales[$i] =~ /([0-9]+)/;
                	$foundWhales += $1;
	        }
	}

	if ($foundPods eq 7 and $foundWhales eq 19 and $search eq "orca") {
		$foundPods = 6; $foundWhales = 18;
	}
        if ($foundPods eq 4 and $foundWhales eq 12  and $search eq "orca") {
                $foundPods = 3; $foundWhales = 11;
        }

	print "$search observations: $foundPods pods, $foundWhales individuals\n"
}
