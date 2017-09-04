#!/usr/bin/perl
if ($ARGC == 2) {
	$courseCode = $ARGV[2];
}
else {
	$courseCode = $ARGV[1];
}


sub FindPre {
@args = @_;
$courseCode = $args[0];
$courseNum = $courseCode;
$courseNum =~ s/[A-Z]//g;
$courseType = "undergraduate";
if ($courseNum >= 5000) {
	$courseType = "postgraduate";
}
$url = "http://www.handbook.unsw.edu.au/$courseType/courses/current/$courseCode.html";
#print $url;
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
	if ($line =~ /Prerequisite(s)?:/) {
		$rawPrereq = $line;
	}
}
$rawPrereq =~ s/\s+<p>Prerequisite(s)?: //;
$rawPrereq =~ s/(<\/p>).*//;
$rawPrereq =~ s/(\s*or\s*)|(, and)/\n/g;
$rawPrereq =~ s/(\sand\s)/\n/g;
$rawPrereq =~ s/\.//g;
@prereqs = split "\n", $rawPrereq;
return @prereqs;
}



my @base = ();
my @prereqs = FindPre($courseCode);

foreach $r (@prereqs) {
        push @base, $r;
}

foreach my $r (@base) {
        @subreqs = FindPre($r);
	for my $s (@subreqs) {
		if ($s ~~ @base) {
		} else {
			push @base, $s;
		}
	}	
}

foreach $r (@base) {
	print $r, "\n";
}
