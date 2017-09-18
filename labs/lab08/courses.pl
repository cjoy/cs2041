#!/usr/bin/perl -w
my $url = "http://www.timetable.unsw.edu.au/current/$ARGV[0]KENS.html";
open F, "wget -q -O- $url|" or die;
while (my $line = <F>) {
	chomp $line;
	if ($line =~ "<td class=\"data\"><a href=\"$ARGV[0]" ) {
		$line =~ s/<td class=\"data\"><a href=\"$ARGV[0]//g;
		$line =~ s/\d+.html\">//g;
		$line =~ s/<\/a><\/td>//g;
		if ($line =~ $ARGV[0]) {
			$line =~ s/\s+//g;
			print $line, "\n";
		}
	}
}
