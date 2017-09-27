#!/usr/bin/python3
import sys

n = int(sys.argv[1])

def cleanLine(line):
	sub_line = line.split()
	sub_line_array = []
	for l in sub_line:
		sub_line_array.append(l.lower())
	new_line = str(" ".join(sub_line_array))
	return new_line



uniq = []
nr = r = 0

for l in sys.stdin:
	line = cleanLine(l)
	# uniq lines execed n
	if len(uniq) >= n:
		nr += 1
	# while uniq_lines less than n
	if len(uniq) < n:
		if line not in uniq:
			uniq.append(line)
		r += 1


#print(r, nr)
#print(len(uniq))

if r+nr < n:
	print("End of input reached after",r,"lines read - ",n,"different lines not seen.")
else:
	print(len(uniq),"distinct lines seen after",r,"lines read.")

#if nr > 0:
#	print("End of input reached after",r,"lines read - ",n,"different lines not seen.")
#else:
#	print(len(uniq_lines),"distinct lines seen after",r+nr,"lines read.")




#n = int(sys.argv[1])
#lines = []

#seen = 0
#notseen = 0
#total = 0
#for line in sys.stdin:
#	if len(lines) < n:
#		seen += 1
#		new_line = cleanLine(line)
#		if (new_line not in lines):
#			lines.append(new_line)
#	else:
#		notseen += 1
#	
#	total += 1


#print(total, seen, notseen)


#if notseen > 0:
#	print("End of input reached after",total,"lines read - ",n,"different lines not seen.")
#else:
#	print(len(lines),"distinct lines seen after",total,"lines read.")
