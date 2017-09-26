#!/usr/bin/python3
import sys

num = int(sys.argv[1])


dist_lines = []
seen_lines = []

for line in sys.stdin:
	# clean up line
	sub_line = line.split()
	sub_line_array = []
	for l in sub_line:
		sub_line_array.append(l.lower())
	new_line = str(" ".join(sub_line_array))

	if new_line not in dist_lines:
		dist_lines.append(new_line)
	else:
		seen_lines.append(new_line)


if (len(seen_lines)+len(dist_lines) >= num):
	print(len(dist_lines), "distinct lines seen after", len(dist_lines) + len(seen_lines), "lines read.")
else:
	print("End of input reached after", len(dist_lines) + len(seen_lines),"lines read -", num,"different lines not seen.")
# print(dist_lines, seen_lines)