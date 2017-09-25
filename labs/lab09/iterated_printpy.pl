#!/usr/bin/perl


$n = $ARGV[0];
$l = $ARGV[1];

sub printPy {
	@par = (@_);
	$l = $par[0];
	$l =~ s/\'\'\'\)\';//g;
	$py = "#!/usr/bin/python3\nprint(\'\'\'$l\'\'\')";
	return $py;
}


sub printPl {
        @par = (@_);
	$l = $par[0];
        $pl = "#!/usr/bin/perl\nprint '$l';";
        return $pl;
}

print printPy(printPl(printPy($l)));
