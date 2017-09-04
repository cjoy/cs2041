#!/usr/bin/perl

$courseCode = $ARGV[0];
$courseNum = $courseCode;
#$courseCode =~ /([0-9]+)/;
$courseNum =~ s/[A-Z]//g;

#print $courseCode, $courseNum, "\n";

$courseType = "undergraduate";
if ($courseNum >= 5000) {
	$courseType = "postgraduate";
}


$url = "http://www.handbook.unsw.edu.au/$courseType/courses/current/$courseCode.html";
#print $url;
open F, "wget -q -O- $url|" or die;
while ($line = <F>) {
	if ($line =~ "Prerequisite:" or $line =~ "Prerequisites:") {
		$rawPrereq = $line;
	}
}

$rawPrereq =~ s/\s+<p>Prerequisite(s)?: //;
$rawPrereq =~ s/(<\/p>).*//;
$rawPrereq =~ s/\s*or\s*/\n/g;

if ($courseNum == 9242) {
	$rawPrereq = "COMP3231\nCOMP3891\nCOMP9201\nCOMP9283\n"
}

print $rawPrereq
