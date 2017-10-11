
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
	$string = assignTranslate($string);
	$string =~ s/\(/ /g;
	$string =~ s/\,//g;
	$string =~ s/\)/ /g;
	@components = split / /, $string;
	if ($components[5] =~ /\d/) {
		$components[5] = $components[5] - 1;
	}

	if ($components[4] =~ /len/) {
		$components[4] =~ s/len//g;
	}
	if ($components[5] =~ /sys\.argv/) {
		$components[5] =~ s/sys\.argv/\@ARGV/g;
	}

	return "foreach $components[1] ($components[4]..$components[5]) {";
}


sub forargTranslate {
	$string = $_[0];
	@components = split / /, $string;

	return "foreach \$$components[1] (\@ARGV) {";
}

sub forfileinTranslate {
	$string = $_[0];
	@components = split / /, $string;

	return "while (\$$components[1] = <>) {";
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
	# CONVERT PRINT ARGS
	if ($finalString =~ /print \(\$ARGV\[\$1\:-1\]/) {
		$finalString = "print join(\" \", \@ARGV), \"\\n\""
	}

	return $finalString;
}


sub assignTranslate {
	my $again = 0;
	my $quote = 0;
	my $final= "";
	@components = split (" ", $_[0]);
	foreach $components (@components) {
		if ($again == 1) {
			$quote = 0;
			$again = 0;
		}
		if ($components =~ /[a-z]+/) {
				if ($components =~ /\".+\"/ || $components =~ /\'.+\'/) {
					$again = 1;
					$quote = 1;
				}

				elsif ($components =~ /\'/ || $components =~ /\"/) {
					$quote = !$quote;
				}

				elsif ($quote == 0) {
					$components = "\$$components";
					$components =~ s/(^\s*)//;
					$components =~ s/\bor\b/\|\|/g;
					$components =~ s/\band\b/\&\&/g;
					$components =~ s/\bnot\b/\!\=/g;
				}
		}

		elsif ($quote == 1 && $components =~ /\+/) {
			$components = '.';
		}

		if ($final ne "") {
			$final .= " ";
		}

		$final .= $components;
	}
	if ($final =~ /\[/) {
		@components = split ("\\[", $final);
		$final = "$components[0]\[\$$components[1]";
	}
	$final =~ s/\/\//\//g;

	if ($final =~ /\$len/) {
		$final =~ s/\$len/@/g;
		$final =~ s/\(//g;
		$final =~ s/\)//g;
	}


	if ($final =~ /sys\.argv\[(.*)\]/) {
		$final = "\$ARGV[$1-1]";
	}


	return $final;
}




sub arrayTranslate {
	$string = $_[0];
	@components = split ("=", $string);
	$identifier = $components[0];
	$part = $components[1];
	$part =~ s/\]//g;
	$part =~ s/\[//g;
	$part =~ s/ //g;
	$final = "\@$identifier = \( $part \)";
	return $final;
}


# IF STATMENT TRANSLATOR
sub conditionTranslate {
	$string = $_[0];
	$string =~ s/\$if//;
	$string =~ s/\$\&\&/&&/;
	$string =~ s/\$\!\=/!=/;
	$string =~ s/\$\|\|/||/;
	return $string;
}


# PTHON RE.SUB TRANSLATE i.e  using perl's split
sub subTranslate {
	$string = $_[0];
	@components = split /=/, $string;
	# $components[0] = s/s//g;
	$identifier = $components[0];
	$identifier =~ s/\s//g;

	@nextcomponent = split /=/, $string;
	$value = $nextcomponent[1];
	$value =~ s/^.*.\(//g;
	$value =~ s/\).*$//g;
	@regextree = split /,/, $value;
	$regTarget = $regextree[0];
	$regTarget =~ s/r\'//g;
	$regTarget =~ s/\'//g;

	$regDest = $regextree[1];
	$regDest =~ s/\s\'//g;
	$regDest =~ s/\'//g;

	# print "$value\n";

	return "\$$identifier \=\~ s/$regTarget/$regDest/g";
}




1;