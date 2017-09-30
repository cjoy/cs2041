#!/usr/bin/perl -w

# Template written by Prof. Andrew Taylor.

# global translation variables
my @brackets;
my $currTab = 0;
my $prevTab = 0;

# helper functions

# current tab for line

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


while ($sentence = <>) {

	# split sentence incase of single line programs
	if ($sentence !~ /\: \"\)/) {
		@subset = split (/[;:]/, $sentence);
	} else {
		undef @subset;
		push @subset, $sentence;
	}

	foreach $line (@subset) {
	if ($line =~ /^\s*$/ || $line =~ /import/) {} else {
		# $prevTab = $currTab;
		# $currTab = tabIndex($line);
		# print $currTab;
		# printTab($currTab);
		# if ($currTab < $prevTab) {
		# 	print "}\n";
		# 	pop (@brackets)
		# }


		$prevTab = $currTab;
		$currTab = tabIndex($line);
		if ($currTab < $prevTab) {
			printTab($currTab);
			print "}\n";
			pop (@brackets)
		}
		# print $currTab;
		printTab($currTab);


	    # SHEBANG INTERPRETER LINE
	    if ($line =~ /^#!/ && $. == 1) {
	        $line = "#!/usr/bin/perl -w\n";
	    }
	    # COMMENTS
	    elsif ($line =~ /^\s*(#|$)/) {
	    	$line = $line;
		}
		# PRINT STATMENT
	    elsif ($line =~ /^\s*print\((.*)\)$/) {
			$line = printTranslate($line);
	        $line .= ";"
	    }
	    # SYSTEM OUT
	    elsif ($line =~ /sys.stdout.write\((.*)\)/) {
	    	#pass in sysout param instead of $line
	    	$line = sysoutTranslate($1);
	    	$line .= ";";
	    }
	    # SYSTEM IN
	    elsif ($line =~ /sys.stdin.readline/) {
	    	#pass in sysout param instead of $line
	    	$line = sysinTranslate($line);
	    	$line .= ";";
	    }
	    # IGNORE ARRAY INIT
	    elsif ($line =~ /\= \[\]/) {
	    	$line = "";
	    }
	    # ASSIGNMENT STATEMENT
	    elsif ($line =~ /=/
				&& $line !~ /(\s+|^)if\s+/
				&& $line !~ /\belif\b/
				&& $line !~ /(\s+|^)while\s+/) {
	        $line =  assignTranslate($line);
	        $line .= ";"
	    }
	    # WHILE STATEMENT
	    elsif ($line =~ /(\s+|^)while\s+/) {
	    	$line = whileTranslate($line);
	    	push (@brackets, "\{");
	    }

	    # FOR STDIN STATEMENT
	    elsif ($line =~ /for \w+ in sys.stdin/) {
	    	$line = forstdinTranslate($line);
	    	push (@brackets, "\{");
	    }

	    # FOR STATEMENT
	    elsif ($line =~ /(\s+|^)for \w+ in\s+/) {
	    	$line = forTranslate($line);
	    	push (@brackets, "\{");
	    }
	    # IF STATEMENT
	    elsif ($line =~ /(\s+|^)if\s+/) {
	    	$line = ifTranslate($line);
	    	push (@brackets, "\{");
	    }
	    # ELSE IF STATEMENT
	    elsif ($line =~ /(\s+|^)elif\s+/) {
	    	$line = elifTranslate($line);
	    	push (@brackets, "\{");
	    }
	    # ELSE STATEMENT
	    elsif ($line =~ /else/) {
	    	$line = elseTranslate($line);
	    	push (@brackets, "\{");
	    	printTab($currTab);
	    }
	    # ELSE STATEMENT
	    elsif ($line =~ /break/) {
	    	$line = "last;";
	    }
	    # ELSE STATEMENT
	    elsif ($line =~ /append/) {
	    	$line = appendTranslate($line);
	    }





	    # UNTRANSLATABLE LINES
	    else {
	        $line = "#$line";
	    }
	    # PRINT EXCLUDING IGNORED LINES
	    print "$line\n";

	}}

}


closeBrackets();


sub ifTranslate {
	$string = $_[0];
	$string =~ s/if //g;
	$string = assignTranslate($string);
	return "if ($string) {";
}


sub elifTranslate {
	$string = $_[0];
	$string =~ s/elif //g;
	$string = assignTranslate($string);
	return "elsif ($string) {";
}

sub elseTranslate {
	$string = $_[0];
	$string =~ s/else //g;
	return "else {";
}


sub appendTranslate {
	$string = $_[0];
	@components = split /\./, $string;
	$subArr = $components[0];
	$subArr =~ s/\s+//g;
	$sub = $components[1];
	$sub =~ s/^.*.\(//g;
	$sub =~ s/\)$//g;
	return "push \@$subArr, \$$sub";
}

sub whileTranslate {
	$string = $_[0];
	$string =~ s/while //g;
	$string = assignTranslate($string);
	return "while ($string) {";
}

sub forTranslate {
	$string = $_[0];
	$string =~ s/\(/ /g;
	$string =~ s/\,//g;
	$string =~ s/\)/ /g;
	$string = assignTranslate($string);
	@components = split / /, $string;
	if ($components[5] =~ /\d/) {
		$components[5] = $components[5] - 1;
	}
	return "foreach $components[1] ($components[4]..$components[5]) {";
}



sub forstdinTranslate {
	$string = $_[0];
	@components = split / /, $string;

	return "foreach \$$components[1] (<STDIN>) {";
}


sub sysoutTranslate {
	return "print $_[0]"
}


sub sysinTranslate {
	$string = $_[0];
	@components = split /=/, $string;
	$var = $components[0];
	$var =~ s/ //g;
	# $components[0] = s///g;
	return "\$$var = <STDIN>"
}



sub printTranslate {
	$string = $_[0];
	$endLine = "";
	if ($string !~ /end=''/) {
		$endLine = "\\n";
	}

	$string =~ /^\s*print\((.*)\)$/;
	$transString = assignTranslate($1);

	$finalString = "print \"$endLine\"";
	if ($transString ne "") {
		$finalString = "print \($transString, \"$endLine\"\)";
	}

	# remove end=''
	$finalString =~ s/, end=\'\', \"\"//g;

	return $finalString;
}


sub conditionTranslate {
	$string = $_[0];
	$string =~ s/\$if//;
	$string =~ s/\$\&\&/&&/;
	$string =~ s/\$\|\|/||/;
	$string =~ s/\$\!\=/!=/;
	return $string;
}




# Credit: This assignment translation function has been adapted from Perthon on sourceForge
sub assignTranslate {
	my $letter= "";
	my $reset = 0;
	my $inQuote = 0;

	@section = split (" ", $_[0]);
	foreach $section (@section) {
		if ($reset == 1) {
			$inQuote = 0;
			$reset = 0;
		}
		if ($section =~ /[a-z]+/) {
				if ($section =~ /\".+\"/ || $section =~ /\'.+\'/) {
					$inQuote = 1;
					$reset = 1;
				} elsif ($section =~ /\"/ || $section =~ /\'/) {
					$inQuote = !$inQuote;
				} elsif ($inQuote == 0) {
					$section = "\$$section";
					$section =~ s/(^\s*)//;
					$section =~ s/\bnot\b/\!\=/g;
					$section =~ s/\band\b/\&\&/g;
					$section =~ s/\bor\b/\|\|/g;
				}
		} elsif ($section =~ /\+/ && $inQuote == 1) {
			$section = '.';
		}

		if ($letter ne "") {
			$letter .= " ";
		}
		$letter .= $section;
	}

	if ($letter =~ /\[/) {
		@section = split ("\\[", $letter);
		$letter = "$section[0]\[\$$section[1]";
	}

	$letter =~ s/\/\//\//g;

	# array numbers
	if ($letter =~ /\$len/) {
		$letter =~ s/\$len/@/g;
		$letter =~ s/\(//g;
		$letter =~ s/\)//g;
	}

	return $letter;
}