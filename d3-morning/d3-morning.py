#!/usr/bin/env python3

#argument 1 is the pattern we are looking for
#argument 2 is the file we are looking for

import sys

grep_pattern = sys.argv[1]
my_file = open (sys.argv[2])

i=0
for line in my_file:
    #print(line)
    if grep_pattern in line:
        print ("program found "+grep_pattern+" on line " +str(i))
    i=i+1

my_file.close()