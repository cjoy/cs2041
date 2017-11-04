#!/usr/bin/python3
import sys
import os

def calcAverage(arr):
    total = 0
    for a in arr:
        total += a
        
    return total/len(arr)

courses = {}

f = open("enrollments.txt", 'r')
for line in f:
    entry = line.split()
    key = entry[1]+" "+entry[2]+" "+entry[3]
    if key not in courses:
        courses[key] = [int(entry[4])]
    else:
        courses[key].append(int(entry[4]))
f.close()


lookup = sys.argv[1]

for course in courses:
    if lookup.lower() in course.lower():
        print(course, calcAverage(courses[course]))
