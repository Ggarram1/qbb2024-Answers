#1/usr/bin/env python3

import sys

my_file = open (sys.argv[1])

for my_line in my_file:
    if "##" in my_line:
        continue
    fields = my_line.split("\t")
    if "gene" == fields[2]:
        print (fields)

my_file.close()