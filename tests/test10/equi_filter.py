#!/usr/bin/python3


import sys


lines = []
for line in sys.stdin:
	lines.append(line)


for line in lines:
	words = line.split()

	
	for word in words:
		chars = {}
		
		# index character count 
		for char in tuple(word):
			if char.lower() in chars:
				chars[char.lower()] += 1
			else:
				chars[char.lower()] = 1
	
		# delete spaces
		if '' in chars:
			del chars['']
		# set standard
		val = list(chars.values())[0]
		
		print_word = True

		for char in chars.keys():
			if chars[char] != val:
				print_word = False


		if print_word == True:
			print(word, end=" ")




	print()
