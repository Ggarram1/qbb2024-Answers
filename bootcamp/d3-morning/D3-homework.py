#!/usr/bin/env python

import sys

import numpy

#first open file
#skip 2 lines
#split column header by tabs and skip first two entries
fs = open(sys.argv[1], mode='r')
fs.readline()
fs.readline()
line = fs.readline()
fields = line.strip("\n").split('\t')
tissues=fields[2:]

#for question 1:
#create way to hold gene names
#create way to hold gene IDs
#create way to hold expression values

gene_names =[]
gene_IDs = []
expression = []
#for each line:
for line in fs:
#   split line
    fields = line.strip("\n").split("\t")
#   save field 0 into gene IDs
    gene_IDs.append(fields[0])
#   save field 1 into gene names
    gene_names.append(fields[1])
#   save 2+ into expression values
    expression.append(fields[2:])
fs.close()

gene_IDs = numpy.array(gene_IDs)
gene_names = numpy.array(gene_names)
expression = numpy.array(expression, dtype = float)

# print(tissues)
# print(gene_IDs)
# print(gene_names)
# print(expression)
# ^for question 2

#as the expression data appears numerical but is not integers, the program would misinterpret what type of data this is.
#For the string data, the program is able to correctly identify the data type.

#question 3 removed

#question 4:
# mean=numpy.mean(expression[:10,:], axis = 1)
# print(mean)

#question 5
# mean=numpy.mean(expression)
# median=numpy.median(expression)
# print(mean)
# print(median)
#the mean of the expression level across the data set is 16.56, while the median is 0.027. This is likely due to most genes in the dataset
#being expressed at lower levels but there is/are outlier(s) that are bringing the mean up.

#question 6
expression_log = (expression+1)
#print(expression_log[:10,:])
expressionlogfr = numpy.log2(expression_log)
#print(expressionlogfr.shape)
#print(expressionlogfr[:10,:])

#print(expressionlogfr[:10,:])

mean=numpy.mean(expressionlogfr)
median=numpy.median(expressionlogfr)
#print(mean)
#print(median)
#following the log2 transformation, the mean falls to 1.12 while the median is only slightly raised (0.039). These still 
#follow the same pattern as the non-transformed data

#question 7
expressioncopy = numpy.copy(expressionlogfr)
#print(expressioncopy)
expressionsorted = numpy.sort(expressioncopy, axis=1)
#print(expressionsorted)

lastcol = expressionsorted[:,-1]
diff_array = lastcol - expressionsorted[:,-2]
#print(diff_array)
#the difference between the the maximum and the one in the column prior

#question 8
diff_array2=numpy.where(diff_array >10)
#print(diff_array2[0])
print(len(diff_array2[0]))
#33 genes!
