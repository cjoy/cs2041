#!/usr/bin/perl

@whales = ();

while ( ($line = <STDIN>) =~ /\S/ ) {
	push @whales, $line;
}



$search = $ARGV[0];

$foundPods = 0;
$foundWhales = 0;

for ($i = 0; $i < @whales; $i++) {
	if ($whales[$i] =~ $search) {
		$foundPods += 1;
		$whales[$i] =~ /([0-9]+)/;
		$foundWhales += $1;
	}
}

print "$search observations: $foundPods pods, $foundWhales individuals\n"
