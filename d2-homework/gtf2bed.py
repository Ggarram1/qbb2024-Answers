#!/usr/bin/env python3

import sys

file = open(sys.argv[1])

#this removes the text lines in the file^

##this opens the file
for line in file:
    if "##" in line:
        continue
    fields = line.split("\t")
    final_column = fields[8].split(";")
    if fields[2] == "gene":
        gene_name = final_column[2].lstrip("gene_name\"").rstrip("\"")
        print(fields[0]+"\t"+fields[3]+"\t"+fields[4]+"\t"+gene_name)

  

 

    file.close