#!/usr/bin/python3
import sys

fines = {}
for line in sys.stdin:
    name = line.split()[0]
    fine = int(line.split()[1])

    if name not in fines:
        fines[name] = fine
    else:
        fines[name] += fine

mname = list(fines)[0]
mfine = fines[mname]

for name in fines:
    if fines[name] > mfine:
        mname = name
        mfine = fines[name]
    
print("Expel",mname,"whose library fines total $"+str(mfine))
