#!/usr/bin/perl

$num = 0;

foreach $arg (@ARGV) {
    	if ($arg eq "--version") {
        	print "$0: version 0.1\n";
        	exit 0;
    	}
    	# handle other options
    	# ...
	elsif ($arg =~ /^-\d+$/) {
		$num = abs($arg);
	}
	else {
		push @files, $arg;
	}
}

if (@ARGV >= 1) {

foreach $f (@files) {
	open F, '<', $f or die "$0: Can't open $f: $!\n";
	
	$ln=`wc -l $f | cut -d' ' -f1`;	

	if (@files == 1 && $num > 0) {
                $i=$ln;
		while ($r = <F>) {
			if ($i <= $num) {
                        	print $r
			}
			$i-=1;
                }
	} elsif ($num == 0 && @files == 1) {
                $num=10;
		$i=$ln;
                while ($r = <F>) {
                        if ($i <= $num) {
                                print $r
                        }
                        $i-=1;
                }
	} else {
		print "==> $f <==\n";
                $i=$ln;
		while ($r = <F>) {
                        if ($i <= $num) {
                                print $r
                        }
                        $i-=1;
                }
	}
	close F;
}

} else {
	
	$ln=0;
	while (($s = <STDIN>) =~ /\S/) {
        	push @lines, $s;
		$ln+=1;
	}

        $num=10;
        $i=$ln;
	foreach $line (@lines) {
		if ($i <= $num) {
        		print "$line"
		}
		$i-=1;
	}
}
