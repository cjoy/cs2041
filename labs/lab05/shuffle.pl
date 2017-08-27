#!/usr/bin/perl

$i=0;
while (($s = <>) =~ /\S/ ) {
        push @lines, $s;
	$i+=1;
}

@printed = ();

# loop until the # of printed elements = # of lines
while (@printed < $i) {
	#generate random number in the range of the length of lines
	$rn = int(rand($i));
	if($lines[$rn] ~~ @printed) {
		#do nothing if it's already been printed
	} else {
		print $lines[$rn];
                push @printed, $lines[$rn];
	}
}
