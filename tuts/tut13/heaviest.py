#!/usr/bin/python3

import sys

numbers = {}
for arg in sys.argv[1:]:
    if int(arg) not in numbers:
        numbers[int(arg)] = 1
    else:
        numbers[int(arg)] += 1

mval = list(numbers)[0]
mweight = 0

for num in numbers:
    if numbers[num]*num > mweight:
        mweight = numbers[num]*num
        mval = num

print(mval)
