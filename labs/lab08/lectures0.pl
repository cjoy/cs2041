#!/usr/bin/perl


foreach my $code (@ARGV) {

	#my $code = $ARGV[0];
	my $url = "http://timetable.unsw.edu.au/current/$code.html";

	open F, "wget -q -O- $url|" or die;

	my $lecStart = 0;
	my $lecCount = 0;
	my $semStart = 0;
	my $semCount = 0;
	my %classMap;

	while (my $line = <F>) {
		chomp $line;
	

	        # semester num
	        if ($line =~ "Lecture</a></td>") {
	                $semStart = 1;
	        }
	        if ($semStart == 1) {
	                $semCount++;
	        }
	        if ($semCount == 2) {
	                $semLine = $line;
	                $semLine =~ s/<td class=\"data\"><a href=\"\#//g;
	                $semLine =~ s/-.*//g;
	                $semLine =~ s/\s+//g;       
	                $semStart = 0;
	                $semCount = 0;
	        }

	        # lecture time
	        if ($line =~ "Lecture</a></td>") {
	                $lecStart = 1;
	        }
     	   	if ($lecStart == 1) {
        	        $lecCount++;
	        }
	        if ($lecCount == 7) {
        	        $lecLine = $line;
                	$lecLine =~ s/<td class=\"data\">//g;
                	$lecLine =~ s/<\/td>//g;
        	        $lecLine =~ s/^\s+//g;
			$classMap{$lecLine} = $semLine;
        	        $lecStart = 0;
                	$lecCount = 0;
	        }

	}

	my @nClass;
	foreach my $key (sort keys %classMap) {
		if ($key ne "") {
			push @nClass, "$classMap{$key} $key";
		}
	}

	foreach my $key (sort @nClass) {
		print "$code: $key\n";
	}

}
