#!/usr/bin/env python3

import sys

### 3.1: Parse thru VCF file ###

#establish lists outside of for loop
allele_frequency = []
read_depths = []

#use (heavily modified) for-loop to parse thru VCF file
with open(sys.argv[1]) as f:
    for line in f:
        #remove newline characters
        line = line.rstrip("\n")
        
        #skip metadata lines (lines starting with '##')
        if line.startswith('##'):
            continue
        
        #process the header line (starts with '#') and store these data for later!
        if line.startswith('#'):
            #split based on tabs
            header = line.split("\t")
            #pull out info column
            info_pos = header.index("INFO")
            #pull out format column
            format_pos = header.index("FORMAT")
            #specify column position for samples
            sample_pos = list(range(format_pos + 1, len(header)))
            continue

        #split fields based on tabs
        fields = line.split("\t")
        info_field = fields[info_pos]
        
        #assign allelic frequency to new variable
        af = next((item.split("=")[1] for item in info_field.split(";") if item.startswith("AF=")), None)
        
        #when af exists, add it to earlier initialized allele_frequency list and then convert to float for later
        if af:
            allele_frequency.append(float(af))  # Convert AF to float for future processing

       #pull out read depth (DP) for each sample based on format field and split into individual elements using :
        format_field = fields[format_pos]
        format_fields = format_field.split(":")
        
        #find the index of the "DP" field in the format column
        dp_index = format_fields.index("DP") if "DP" in format_fields else None
        
        #extract the read depth (DP) using same logic as above and append to list
        if dp_index is not None:
            for sample in sample_pos:
                sample_data = fields[sample].split(":")
                dp_value = sample_data[dp_index]
                read_depths.append(dp_value)

### 3.2.py: Allele frequency spectrum ###
#write the allele frequencies to a new file "AF.txt"
with open("AF.txt", "w") as file:
    #writes header of new file
    file.write("Allele_Frequency\n")  
    #write each allele frequency on a new line of the file
    for frequency in allele_frequency:
        file.write(f"{frequency}\n") 

### 3.3.py: Read depth distribution ###
# Write the read depths to a new file "DP.txt"
with open("DP.txt", "w") as file:
    #writes header of new file
    file.write("Read_Depth\n")
    #writes each read depth on a new line of the file
    for depth in read_depths:
        file.write(f"{depth}\n")


