sub closeBrackets {
	while ($#brackets + 1 > 0) {
		# printTab(1);
		pop (@brackets);
		print ("\}\n");
		$currTab--;
	}
}

sub tabIndex {
	if (defined $_[0]) {
		$string = $_[0];
		$string =~ /^(\s+)/;
		$currTab = length($1);
		if (defined $currTab) {
			return $currTab;
		} else {
			return 0;
		}
	}
	return 0;
}

sub printTab {
	# fix single line tabs
	if ($_[0] == 1) {
		$_[0] = 4;
	}
	print " "x$_[0];
}


1;