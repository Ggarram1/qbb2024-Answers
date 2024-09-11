#!/usr/bin/env

#numpy is an external product so must first be imported
import numpy

#this creates an array with no values set, then shows the dimensional numbers for array size (tuple), and, finally, sets the type of data to be held by the array.
array = numpy.empty ((4,3), float)

#this creates a 1D array of the data in the square brackets
gorilla = numpy.array([1.1,2,3])
#this shows the shape of the new "gorilla" array
gorilla.shape
#this shows the type of the data in the "gorilla" array
gorilla.dtype

#this shows the 0th index through the end-1
numpy.arrange(end)
#this shows the startth through the end-1
numpy.arrange(start, end)

#this would make a 1D array of the numbers 0-17
A=numpy.arange(18)
#this reorganizes the array into three rows and six columns - this is not a real change to A
A.reshape(3,6)

a=numpy.zeros ((3,2), int)
a[0,0] =5 
a[:1] = numpy.arange(3)

L=[[0,1,2,3], [5,4,3,2], [2,3,2,1]]
A=numpy.array(L)
mean=numpy.mean(A)
print(mean)

row_mean = numpy.mean(A, axis=1)
print(row_means)

column_mean = numpy.mean(A, axis=0)

#using indices to get column maximum values
col_i = numpy.arrange(4) # [0 1 2 3]
maxes = A [max_i, col_i]
print (maxes)