#!/usr/bin/python3


import sys

numbers = []
for num in sys.argv[1:]:
    numbers.append(int(num))

numbers = sorted(numbers)
le = int(len(numbers)/2)

print(numbers[le]);
