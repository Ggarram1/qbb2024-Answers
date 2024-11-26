#!usr/bin/env bash

### 1 ###
### Question 1.1: How long are the sequencing reads? ###
#head -n 2 A01_09.fastq | tail -n 1 | wc -m
#     77
#Each sequencing read is 77 base pairs in length

### Question 1.2: How many reads are present within the file? ###
# x= wc -l A01_09.fastq    
#     2678192
# echo $((x/4))  
#     669548
#At four lines per read, by counting the number of lines in file we can divide by four to determine number of reads.
#There were 669,548 reads in this assay.

### Question 1.3: Given your answers to 1.1 and 1.2, as well as knowledge of the length of the S. cerevisiae reference genome ###
### what is the expected average depth of coverage? ### 
#length of S. cerevisiae genome = 12.1Mb
#At 77bp per read and 669548 reads, there are 51555196 bases covered during in this sequencing
#We know there are 12100000 bases in the genome, so we can divide the number of bases covered by number of bases in the genome to
#determine the x-coverage of the genome.
#51555196/12100000 = 4.26X coverage

### Question 1.4: Which sample has the largest file size (and what is that file size, in megabytes)? Which sample has the smallest###
### file size (and what is that file size, in megabytes)?###
# du -h A01_*.fastq
#   122M	A01_09.fastq
#   119M	A01_11.fastq
#   129M	A01_23.fastq
#   145M	A01_24.fastq
#   110M	A01_27.fastq
#   111M	A01_31.fastq
#   146M	A01_35.fastq
#   130M	A01_39.fastq
#   149M	A01_62.fastq
#   113M	A01_63.fastq
#The sample with the largest file size is "A01_62", at 149MB. The sample with the smallest file size is "A01_27", at 110MB.

### Question 1.5 ###
#fastqc A01_*
###Question 1.5.1: What is the median base quality along the read? ###
#The median base quality along the read is 37 (seen in "per sequence quality scores").
###Question 1.5.2: How does this translate to the probability that a given base is an error? ###
#This suggests each base is not likely to be an error, with the phred quality score indicating the probablity
#of a given base call being inaccurate being 0.0002.
###Question 1.5.3: Do you observe much variation in quality with respect to the position in the read? ###
#Early on in the read, the quality is substantially decreased. The phred scores increase as the position in the read increases.
#A similar trend occurs towards the end of the reads, with the quality of the reads decreasing at the ends. Both of these decreases
#in phred scores are likely due to decreased stability of interactions.

### 2 ###
### Question 2.1: How many chromosomes are in the yeast genome? ###
#conda activate qb24 
# fastqc A01_*
# grep ">" sacCer3.fa | wc -l
#     17 
#There are 17 chromosomes in this file.

### Question 2.2: Align reads to reference genome ###
#chmod +x BinBashScript_Week5.sh
# for file in "A01_09.fastq" "A01_11.fastq" "A01_23.fastq" "A01_24.fastq" "A01_27.fastq" "A01_31.fastq" "A01_35.fastq" "A01_39.fastq" "A01_62.fastq" "A01_63.fastq"
# do
#      bwa mem -R "@RG\tID:"${file}"\tSM:"${file}"" sacCer3.fa "${file}" > sacCer_"${file}".sam      
#  done

### Question 2.3.1: How many total read alignments are recorded in the SAM file? ###
#use grep function to count number of lines with "0" - the character indicating line of read alignment
#grep -v "0" sacCer_A01_09.fastq.sam | wc -l 
#   669548
#There are 669,557 total read alignments
### Question 2.3.2: How many of the alignments are to loci on chromosome III? ###
#pipe previous command into another grep function to pull out only alignments on chromosome III
#grep -v "0" sacCer_A01_09.fastq.sam | grep "chrIII" | wc -l
#   18196
#18196 of the 669548 alignments are to loci on chromosome 3.

### Question 2.4: Sort .sam files using samtools sort and create an index for each of the resulting ###
###sorted .bam files using samtools index ###
# for file in "sacCer_A01_31.fastq.sam" "sacCer_A01_11.fastq.sam" "sacCer_A01_24.fastq.sam" "sacCer_A01_24.fastq.sam" "sacCer_A01_27.fastq.sam" "sacCer_A01_09.fastq.sam" "sacCer_A01_35.fastq.sam" "sacCer_A01_39.fastq.sam" "sacCer_A01_62.fastq.sam" "sacCer_A01_63.fastq.sam"
# do
#      samtools sort "$file" -o "${file%.sam}.sorted.bam" && samtools index "${file%.sam}.sorted.bam"
#  done

### Question 2.4.1: Does the depth of coverage appear to match that which you estimated in Step 1.3? ###
#The coverage depth varies substantially, from 8x to 2x depending on the location. Broadly, however, it appears that
#approximately 4x coverage is a likely average level of coverage.

### Question 2.4.2: How many SNPs do you observe in chrI:113113-113343? Are there any SNPs about which you are uncertain? ###
#There are three SNPs within this window - two (at chrI:113,131 and 113,206) are covered by 4-5 reads which suggest they are not 
#artifacts. However, an additional 'SNP' at chrI:113,326 is found only in 2 reads, which does suggest some uncertainty.

### Question 2.4.1: What is the position of the SNP in the window chrIV:825548-825931? Does this SNP fall within a gene? ###
#The SNP in this window is at the locus 825,834. This SNP does not fall within a gene. However, there is another SNP at the locus
#825,565. This SNP is of lower certainty but falls within SCC2.
