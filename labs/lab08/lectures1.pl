#!/usr/bin/perl

use List::MoreUtils qw(uniq);

my @myargs;

my $option = "none";
if ($ARGV[0] eq "-d") {
	$option = "d";
	shift @ARGV;
}

foreach my $code (@ARGV) {

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

	if ($option eq "none") {
		foreach my $key (sort @nClass) {
			print "$code: $key\n";
		}
	}

	if ($option eq "d") {

		 my @mTimes;
		foreach my $key (sort @nClass) {

			@eS = split / /, $key;
			$sem = $eS[0];

			$nkey = $key;
			$nkey =~ s/(S1)|(S2)//g;
			
			@eT = split /\),/, $nkey;

			foreach $t (@eT) {
				$oT = $t;
				$oT =~ s/\(.*//g;
				
				
				@kS = split / /, $oT;
				
				$day = $kS[1];
				$sTime = $kS[2];
				$sTime =~ s/:\d\d//g;
				$fTime = $kS[4];
				$fTime =~ s/:\d\d//g;
				
				my %pTimes;
				for (my $i=$sTime; $i<$fTime; $i++) {
					$pTimes{"$sem $code $day $i"} = "$sem $code $day $i";
				}

				foreach my $ke (sort keys %pTimes) {
					$ke =~ s/ 0/ /g;
					push @mTimes, $ke;
				}
 
			}


                }
	
                @uTimes = uniq(@mTimes);
                foreach my $kr (@uTimes) {
               		print "$kr\n";
                }

	}

}
