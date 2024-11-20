library(tidyverse)
library(broom)
library(ggthemes)

import(sys)

import(numpy)
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
    
#2:determine which tissue scorresponds to which sample_ID
#create key from gene and tissue
    key = (fields[0], fields[2])
#create new dictionary from key with list to hold samples
    rel_samples[key] = []
#print(rel_samples) - to check before continuing the code

#get metadata file name:
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

#print(tissue_samples) - to check before continuing the code

#3:determine sample_IDs present in gene expression file
#get metadata file name:
filename = sys.argv[3]
#open file in read mode
fs=open(filename, mode='r')
#skip two lines
fs.readline()
fs.readline()
#split line into fields and remove next line characters AND set as header
header=fs.readline().rstrip("\n").split("\t")
header = header[2:]

#4+5: determine which columns (sample_ID) are relevent for each tissue and append to 
#Sample_IDs
#create new dictionary for tissue columns
tissue_columns={}
#created nested forloop
for tissue, samples in tissue_samples.items():
    tissue_columns.setdefault(tissue, [])
    for sample in samples:
        if sample in header:
            position = header.index(sample)
            tissue_columns[tissue].append(position)
print(tissue_columns)
#close the file
fs.close()

