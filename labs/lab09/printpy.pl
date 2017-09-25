#!/usr/bin/perl

$l = $ARGV[0];


@ls = split /\n/, $l;

foreach $line (@ls) {
	$line =~ s/\\/\\\\/g;
	if ($line =~ /\"$/) {
		print "#!/usr/bin/python3\nprint('$line')";
	} else {
		print "#!/usr/bin/python3\nprint(\"$line\")";
	}
}
