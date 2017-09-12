#!/usr/bin/python

import sys, re, glob, string, os


def totalWords(file):
	words = []
	f = open(file, 'r')
	for lines in f:
		lines = lines.lower()
		words += re.split(r'[^a-zA-Z]', lines)
	
	words = filter(None, words)
	return len(words)


def countWords(file, word):
        words = []
        f = open(file, 'r')
        for lines in f:
                lines = lines.lower()
                words += re.split(r'[^a-zA-Z]', lines)
        words = filter(None, words)
	
	found = 0
	for w in words:
		if (word == w):
			found += 1

        return found


def getName(unfiltered):
	new = unfiltered.split("/")
	new = new[1]
	new = new.split(".")
	new = new[0]
	new = new.replace("_", " ")
	return new


for file in sorted(glob.glob("lyrics/*.txt")):
	total = totalWords(file)
	count = countWords(file, sys.argv[1])
	freq = float(count)/(total)
	artist = getName(file)
	print "{:4d}/{:6d} = {:.9f} {}".format(count, total, freq, artist)
