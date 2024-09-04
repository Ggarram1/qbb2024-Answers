#!/usr/bin/env python3

import sys
#these first two steps are to establish the environment and the system.

#We also open the files and specify which term is read.
file = open(sys.argv[2])
term = (sys.argv[1])


for line in file:
    line=line.rstrip("\n")
    if term in line:
        print(line)

file.close()
