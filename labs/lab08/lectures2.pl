#!/usr/bin/perl

use List::MoreUtils qw(uniq);

my @myargs;

my $option = "none";
if ($ARGV[0] eq "-d") {
	$option = "d";
	shift @ARGV;
}
if ($ARGV[0] eq "-t") {
        $option = "t";
        shift @ARGV;
}

my @tTab;

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
	

	if ($option eq "t") {
       		foreach my $key (sort @nClass) {
        	        push @tTab, "$code $key";
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



if ($option eq "t") {

	my %timeTable;
	my %classmap;



	foreach my $k (@tTab) {

		$tk = $k;
		@sk = split /\s/, $tk;
		$code = @sk[0];
		$sem = @sk[1];
		
		$lk = $k;
		$lk =~ s/$code $sem //g;
		
		@rk = split /\),/, $lk;
		foreach $ts (@rk) {
			$ts =~ s/\(.*//g;
			$ts =~ s/^\s//g;
		#	print "$sem $code $ts\n";
			$classmap{$sem}{$code}{$ts} = "$sem $code $ts";
		}

	}

	
	foreach $se (keys %classmap) {
		foreach $co (keys $classmap{$se}) {
			foreach $ti (keys $classmap{$se}{$co}) {
#				print "$se $co $ti\n";
				my $ts = $ti;
				my @times =  split / /, $ts;
				my $day = @times[0];
				my $start = @times[1];
				$start =~ s/:\d\d//g;
				$start =~ s/^0//g;
				my $finish = @times[3];
				$finish =~ s/:\d\d//g;
				for (my $i=$start; $i < $finish; $i++) {
#					print " $i\n";
					if(!$timetable{$se}{$day}{$i}) {
						$timetable{$se}{$day}{$i} = 1;
					} else {
						$timetable{$se}{$day}{$i}++;
					}

				}
				


			}
		}
		
	}

	
	foreach my $sem (sort keys %timetable) {
		print "$sem       Mon   Tue   Wed   Thu   Fri\n";

		for (my $time=9; $time < 21; $time++) {
			printf("%02d:00     %s     %s     %s     %s     %s\n",
				$time,
				$timetable{$sem}{"Mon"}{$time} || " ",
                                $timetable{$sem}{"Tue"}{$time} || " ",
                                $timetable{$sem}{"Wed"}{$time} || " ",
                                $timetable{$sem}{"Thu"}{$time} || " ",
                                $timetable{$sem}{"Fri"}{$time} || " "
				);
		}	
	}



}
