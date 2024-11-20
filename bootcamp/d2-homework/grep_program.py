#!/usr/bin/env python3

import sys
#these first two steps are to establish the environment and the system.

# grep_program.py    thing you're looking for     file you look in 
# sys.argv[0]        sys.argv[1]                  sys.argv[2]


#We also open the files and specify which term is read in which order.
file = open(sys.argv[2])
term = (sys.argv[1])

#this, line by line, removes the next-line chacter from each line. Additionally, if there is the term that was specified above, the code will print the line.
for line in file:
    line=line.rstrip("\n")
    if term in line:
        print(line)

#this closes the file
file.close()
