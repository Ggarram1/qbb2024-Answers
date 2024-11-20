#!/usr/bin/env python3

import sys

#lists store a sequence of values
print(sys.argv)

num_arg = len(sys.argv)
print ("Number of arguments:" + str(num_arg))

i = 0
for my_arg in sys.argv:
    print(str(i) +"th argument is "+sys.argv[i])
    i = i + 1