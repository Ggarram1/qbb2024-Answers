#!/usr/bin/env python3

import sys

import numpy
#1:import gene-tissue pairs
#get gene_tissue file name:
filename = sys.argv[1]
#open file in reading mode
fs=open(filename, mode='r')
#create empty dictionary to hold samples for gene-tissue pairs
rel_samples = {}
#step through file
for line in fs:
#split line into fields and remove next line characters
    fields=line.rstrip("\n").split("\t")
    key = (fields[0], fields[2])
#create new dictionary from key with list to hold samples
    rel_samples[key] = []
#print(rel_samples) 

# - to check before continuing the code

#2:determine which tissue scorresponds to which sample_ID
#create key from gene and tissue^ 

#get sample_IDs file:
filename = sys.argv[2]
#open file in reading mode
fs=open(filename, mode='r')
#skip line
fs.readline()
#create new and empty dictionary to hold samples for tissue name
tissue_samples = {}
#step through file
for line in fs:
#split line into fields and remove next line characters
    fields=line.rstrip("\n").split("\t")
#assign key to gene and value to tissue
    key = fields[6] 
    value =fields[0]
#initialize dict from key with list to hold samples
#append the value (column) after the tissue sample 
    tissue_samples.setdefault(key, [])
    tissue_samples[key].append(value)
#close the file
#fs.close()

#print(tissue_samples)
# - to check before continuing the code

#3:determine sample_IDs present in gene expression file
#get expression data file:
filename = sys.argv[3]
#open file in read mode
fs=open(filename, mode='r')
#skip two lines
fs.readline()
fs.readline()
#split line into fields and remove next line characters AND set as header
header=fs.readline().rstrip("\n").split("\t")
header = header[2:]
#print(header) to check if this works

#4+5: determine which columns (sample_ID) are relevent for each tissue and append to 
#Sample_IDs
#create new dictionary for tissue columns
tissue_columns={}
#created nested forloop
for tissue, samples in tissue_samples.items():
    tissue_columns.setdefault(tissue, [])
    for sample in samples:
#if relevent tissue is expressing
        if sample in header:
            position = header.index(sample)
            tissue_columns[tissue].append(position)
#print(tissue_columns)

#for key, value in tissue_columns.items():
#    print(key, len(value))

#First, the maximum value/tissues are initiated to 0 and to ""
max_value = 0
max_tissue = ""

#for loop to check the samples for each tissue
for tissue, samples in tissue_columns.items():
#Only change the max value and max tissue if the number of samples is greater than 0 or the previous one    
    if len(samples)>= max_value:      
        max_value = len(samples)
        max_tissue = tissue

print(max_tissue, max_value)
#organs with greater tissue diversity, skeletal muscle, have the highest nunber of genes. 
#The tissue with the highest number is the skeletal muscle, with 803 genes identified.

#First, the maximum value/tissues are initiated to 1000 (following the previous excercise, we know the tissue with the greatest number) and to ""
max_value = 1000
max_tissue = ""

for tissue, samples in tissue_columns.items():
#for loop to check the samples for each tissue    
    if len(samples)<= max_value:
#Only change the min value and min tissue if the number of samples is less than 1000 or the previous one         
        min_value = len(samples)
        min_tissue = tissue

print(min_tissue, min_value)
#Smaller and less diverse tissues have fewer genes identified. The tissue with the fewest genes identified
#are cells - Leukemia cell line (CML), with 0 counted.

#close the file
#fs.close() 

#question 7 on other doc




