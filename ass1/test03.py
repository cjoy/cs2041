#!/usr/bin/python3
# put your test script here
count = 0

for i in range(0, 10):
    print(i, end=": ")
    if (i % 2 == 0):
        print("Even")
    else:
        print("Odd")