#!/usr/bin/python3

import sys

numbers = []
for line in sys.stdin:
    nums = line.split()
    for num in nums:
        numbers.append(int(num))

diff = numbers[0] - numbers[1] + 1
prev = numbers[0]
for num in numbers[1:]:
    if prev - num >= diff:
        print("not converging")
        exit(0)
    
    diff = prev - num

    if prev <= num:
        print("not converging")
        exit(0)

    prev = num


print("converging")
