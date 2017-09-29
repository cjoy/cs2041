#!/usr/bin/perl -w

# Template written by Andrew Taylor










while ($line = <>) {
    # translate #! line
    if ($line =~ /^#!/ && $. == 1) {
        $line = "#!/usr/bin/perl -w";
    }

    # Blank & comment lines can be passed unchanged
    elsif ($line =~ /^\s*(#|$)/) {
    	$line = $line;
	}

    # Python's print outputs a new-line character by default
    # so we need to add it explicitly to the Perl print statement
    elsif ($line =~ /^\s*print\((.*)\)$/) {
		$line = printTranslate($line);
        $line .= ";"
    }

    # Python Assignment Statements (variables)
    elsif ($line =~ /=/
    		&& $line !~ /(\s+|^)if\s+/
    		&& $line !~ /\belif\b/
    		&& $line !~ /(\s+|^)while\s+/) {
        $line =  assignTranslate($line);
        $line .= ";"
    }

    # Lines we can't translate are turned into comments
    else {
        $line = "#$line";
    }

    print "$line\n";
}









sub printTranslate {
	$string = $_[0];
	$endLine = "";
	if ($string !~ /end=''/) {
		$endLine = "\\n";
	}

	$string =~ /^\s*print\((.*)\)$/;
	$transString = assignTranslate($1);

	return "print \($transString, \"$endLine\"\)";
}





# TODO: Refactor this piece of code
# Credit: This assignment translation function has been inspired & adapted from Perthon on sourceForge
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

	return $letter;
}


