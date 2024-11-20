#!/usr/bin/env

import sys

my_file=open (sys.argv[1])

i=0
for line in my_file:
    if i==10:
        break
    line = line.rstrip ("\n")
    print (line)
    i=i+1
    
my_file.close