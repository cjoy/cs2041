#!/usr/bin/perl -w

# Template written by Prof. Andrew Taylor.

# libraries need for translation
require './lib/helpers.pl';
require './lib/translators.pl';

# global translation variables
our @brackets;
our $currTab = 0;
our $prevTab = 0;

while ($sentence = <>) {
	# split sentence incase of single line programs
	if ($sentence !~ /\: \"\)/ &&
		$sentence !~ /\:\]/ &&
		$sentence !~ /^#/) {
		@subset = split (/[;:]/, $sentence);
	} else {
		undef @subset;
		push @subset, $sentence;
	}

	foreach $line (@subset) {
	if ($line =~ /^\s*$/ || $line =~ /import/) {} else {
		$comment = 0;

		# MANAGE INDENTS & CONTROL FLOW
		$prevTab = $currTab;
		$currTab = tabIndex($line);
		if ($currTab < $prevTab && $line !~ "\t") {
			printTab($currTab);
			print "}\n";
			pop (@brackets)
		}
		# for debugging tab index
		# print $currTab;
		printTab($currTab);

		# START REGEX BASED TRANSLATION

	    # SHEBANG INTERPRETER LINE
	    if ($line =~ /^#!/ && $. == 1) {
	        $line = "#!/usr/bin/perl -w\n";
	    }
	    # COMMENTS
	    elsif ($line =~ /^\s*(#|$)/) {
	    	$line = $line;
	    	$comment = 1;
		}
	    # REGEX SUBSTITUE
	    elsif ($line =~ /\s=\sre\.sub/) {
	    	$line = subTranslate($line);
	    	$line .= ";";
	    }
	    # ARRAYS
	 #    elsif ($line =~ /.+\=.*\[.+\]/) {
	 #    	$line = arrayTranslate($line);
	 #    	$line .= ";";
		# }

		# INIT HASH MAP
		elsif ($line =~ /\s=\s\{\}/) {
			$line = "";
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
	    	push (@brackets, 1);
	    }
	    # FOR ARG
	    elsif ($line =~ /\sin\ssys\.argv\[1:\]/) {
	    	$line = forargTranslate($line);
	    	push (@brackets, 1);
	    }
	    # FOR FILE INPUT
	    elsif ($line =~ /\sin\sfileinput\.input\(\)/) {
	    	$line = forfileinTranslate($line);
	    	push (@brackets, 1);
	    }
	    # FOR STDIN STATEMENT
	    elsif ($line =~ /for \w+ in sys.stdin/) {
	    	$line = forstdinTranslate($line);
	    	push (@brackets, 1);
	    }
	    # FOR STATEMENT
	    elsif ($line =~ /for \w+ in range/) {
	    	$line = forTranslate($line);
	    	push (@brackets, 1);
	    }
	    # IF STATEMENT
	    elsif ($line =~ /(\s+|^)if\s+/) {
	    	$line = ifTranslate($line);
	    	push (@brackets, 1);
	    }
	    # ELSE IF STATEMENT
	    elsif ($line =~ /(\s+|^)elif\s+/) {
	    	$line = elifTranslate($line);
	    	push (@brackets, 1);
	    }
	    # ELSE STATEMENT
	    elsif ($line =~ /else/) {
	    	$line = elseTranslate($line);
	    	push (@brackets, 1);
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
	    if ($comment == 1) {
		    print "$line";
    	} else {
		    print "$line\n";
    	}

	}}

}
# clear brackets - helper
closeBrackets();