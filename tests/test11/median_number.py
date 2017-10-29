#!/usr/bin/python3
import sys
numbers = sorted([int(x) for x in sys.argv[1:]])
middle = int(len(numbers)/2)
print(numbers[middle])