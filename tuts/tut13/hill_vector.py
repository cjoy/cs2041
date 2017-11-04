#!/usr/bin/python3


import sys

vector = []
for line in sys.stdin:
    for n in line.split():
        vector.append(int(n))


if len(vector) <= 2:
    print("not hill")
    exit(0)

isHill = True

apex = 0
prev = vector[0]
status = "uphill"
for curr in vector[1:]:
    if curr > prev:
        status = "uphill"
        if status == "downhill":
            isHill = False
    elif curr < prev and apex == 0:
        status = "apex"
        apex = curr
    elif curr == prev:
        status = "dup apex"
        apex = curr
        isHill = False
    elif curr < prev:
        status = "downhill"
        if status == "uphill":
            isHill = False

        
    prev = curr

if (isHill == True):
    print("hill")
else:
    print("not hill")
