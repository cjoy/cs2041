#!/usr/bin/perl

@numbers = @ARGV;
@numbers = sort {$b <=> $a} @numbers;
$median = int ($#ARGV/2);
print($numbers[$median], "\n");
