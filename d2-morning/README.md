# Day 2 lunch excersise

## BioMart Question 1
### total number of gene biotype:
(qb24) cmdb@QuantBio-03 qbb2024-Answers %

(qb24) cmdb@QuantBio-03 qbb2024-Answers % cd d2-lunch 

(qb24) cmdb@QuantBio-03 d2-lunch % cut -f 7 hg38-gene-metadata-feature.tsv | sort | uniq -c

- 10 IG_C_gene
- 4 IG_C_pseudogene
- 37 IG_D_gene
- 11 IG_J_gene
- 3 IG_J_pseudogene
- 108 IG_V_gene
- 144 IG_V_pseudogene
- 1 IG_pseudogene
- 2 Mt_rRNA
- 22 Mt_tRNA
- 1042 TEC
- 6 TR_C_gene
- 5 TR_D_gene
- 79 TR_J_gene
- 4 TR_J_pseudogene
- 107 TR_V_gene
- 33 TR_V_pseudogene
- 19 artifact
- 1 gene_biotype
- 18804 lncRNA
- 1833 miRNA
- 2146 misc_RNA
- 9987 processed_pseudogene
- 19618 protein_coding
- 46 rRNA
- 492 rRNA_pseudogene
- 8 ribozyme
- 5 sRNA
- 1 scRNA
- 46 scaRNA
- 1875 snRNA
- 931 snoRNA
- 505 transcribed_processed_pseudogene
- 154 transcribed_unitary_pseudogene
- 918 transcribed_unprocessed_pseudogene
- 2 translated_processed_pseudogene
- 95 unitary_pseudogene
- 2525 unprocessed_pseudogene
- 4 vault_RNA 

### total number of protein coding genes:
- 19618 protein_coding genes (as identified above)
- I would like to learn more about the scRNA. There was only one gene biotype identified, so I am curious to learn more about the conditional nature of the RNA.

## BioMart Question 2
### ensembl_gene_id with most go_ids
- (qb24) cmdb@QuantBio-03 d2-lunch % cut -f 1 hg38-gene-metadata-go.tsv | sort -n | uniq -c |sort -n
- ENSG00000168036 (273 Go_IDs)
- Based on the GO terms associated with this gene (Wnt pathways, differentiation, apical cell localization,etc) I think this gene is involed in development and/or cellular maturation.

## GENCODE Question 1
### IG genes/chromosome
- (qb24) cmdb@QuantBio-03 d2-lunch % grep -w "IG\_.\_gene" gene.gtf | cut -f 1 | sort | uniq -c | sort
- 1 chr21
- 6 chr16
- 16 chr15
- 48 chr22
- 52 chr2
- 91 chr14
### Distribution of IG pseudogenes
- (qb24) cmdb@QuantBio-03 d2-lunch % grep -w "IG\_.\_pseudogene" gene.gtf | cut -f 1 | sort | uniq -c | sort
AND
- (qb24) cmdb@QuantBio-03 d2-lunch % grep -w "IG\_.*\_pseudogene" gene.gtf | cut -f 1 | sort | uniq -c | sort
-1 chr1
- 1 chr10
- 1 chr18
- 1 chr8
- 5 chr9
- 6 chr15
- 8 chr16
- 45 chr2
- 48 chr22
- 84 chr14
### Discussion of distributions
There are more pseudogenes on a larger range of chromosomes than there are genes proper. This is logiical as there are more requirements that must be met for protein assembly, thus, pseudogenes may be more likely to develop.

## GENCODE Question 2
### Why grep pseudogene gene.gtf is not an effective way to obtain the above data
Simply "grep"-ing the pseudogene entries out, all rows containing "pseudogene" will be shown. This filters by IG...gene or IG...pseudogene rather than simply the word "pseudogene". 

## GENCODE Question 3
### 