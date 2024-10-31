library(tidyverse)
library(broom)
library(DESeq2)

#1.1 - loading data (below) and libraries (above)
#set working directory to where data and output are stored
setwd("~/qbb2024-Answers/Week 7/")

#load gene expression counts
counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt")
#check first five rows
counts_df[1:5,]
#move the "GENE_NAME" column to row names, so contents of the tibble is numeric
counts_df <- column_to_rownames(counts_df, var = "GENE_NAME")


#load metadata
metadata_df <- read_delim("gtex_metadata_downsample.txt")

#check first five rows
metadata_df[1:5,]
#move the "SUBJECT_ID" from the first column to row names
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")

#check that the columns of the counts are identical and in the same order as the rows of the metadata
colnames(counts_df) == rownames(metadata_df)
#count how many "TRUE" statements
table(colnames(counts_df) == rownames(metadata_df))
#106 True statements

#1.2 - create DESeq object
#create DESeq object, specify the counts, the column data, and the predictor variables
dds <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~ SEX + AGE + DTHHRDY)
#apply VST normalization
vsd <- vst(dds)

#1.3 - Plot PCA
#apply and plot principal components
plotPCA(vsd, intgroup = "SEX")
plotPCA(vsd, intgroup = "AGE")
plotPCA(vsd, intgroup = "DTHHRDY")
#1.3.3 - What proportion of variance in the gene expression data is explained by each of 
#the first two principal components? Which principal components appear to be 
#associated with which subject-level variables? Interpret these patterns in your 
#own words and record your answers as a comment in your code.
  #The first PCA plot, showing the data based on sex, does not appear to explain the data.
  #although there is a substantial amount of variance explained by PCA1, the variance is
  #not related to the grouping/color-coding by sex. The second PCA plot, based on age, also does not 
  #appear to show much relation between the grouping by age and the variance explained by
  #PCA1. The third PCA plot, however, does appear to show a relationship between the grouping
  #and the PCA variance explained.The ventilator case deaths are primarily grouped together while 
  #the death of natural cause cases are primarily grouped together. Across all groups, PC1 
  #accounts for 48% of the variance while PC2 accounts for 7% of the variance. This means that
  #PC1 is likely accounting for the variance due to cause of death. Which variable PC2 is accounting
  #for is a bit more challenging to determine - I might guess age but further analysis is required.

#extract normalized expression data and append to metadata
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()
vsd_df <- bind_cols(metadata_df, vsd_df)

#apply multiple linear regression to particular given gene
m1 <- lm(formula = WASH7P ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
m1

#use DESeq2 to perform differential expression analysis across all genes
dds <- DESeq(dds)

#extract results for sex differential analysis
blood_res <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME")
#2.1.1 Does WASH7P show significant evidence of sex-differential expression 
#(and if so, in which direction)? Explain your answer.
  #There is no significant evidence of sex-differential expression of WASH7P. 
  #This can be seen in the statistic and p.value columns and sex row of the tibble, 
  #with both values being insufficient for statistical significance (1.09, 2.79e-1)
#2.1.2 Now repeat your analysis for the gene SLC25A47. Does this gene show 
#evidence of sex-differential expression (and if so, in which direction)? 
#apply multiple linear regression to particular given gene
m1 <- lm(formula = SLC25A47 ~ DTHHRDY + AGE + SEX, data = vsd_df) %>%
  summary() %>%
  tidy()
m1
#Explain your answer.
  #There is significant evidence of sex-differential expression of SLC25A47, as 
  #seen in the p.value of 0.0257.
blood_res %>%
  filter(!is.na(padj)) %>%
  filter(padj<0.1) %>%
  nrow()
blood_res

#2.2.1 - Apply DESeq to fit linear regression model
dds <- DESeq(dds)
#2.3.1 - Extract results for sex differential expression
res <- results(dds, name = "SEX_male_vs_female") %>%
  as_tibble(rownames = "GENE_NAME")
res <- res %>%
  filter(!is.na(padj)) %>%
  arrange(padj)
res

#2.3.2 - How many genes exhibit significant differential expression between males 
#and females at a 10% FDR?

res <- res %>%
  filter(!padj < 0.1) %>%
  arrange(padj)
res
#a 10% FDR is indicated by genes which have a padj value of < 0.1. There were
#(22,290-22,028-3=259) 259 genes with a significant differential expression between males and females.

#2.3.3 - Examine top hits. 

#open file
gene_loci <- read_delim("gene_locations.txt")
#left join to other data
merged_df <- left_join(blood_res, gene_loci, by = "GENE_NAME") %>% 
  arrange(padj)
#arrange tibble and filter out N/A
res <- merged_df %>%
  filter(!is.na(padj)) %>%
  arrange(padj)
res

#Which chromosomes encode the genes that are most strongly upregulated in males 
#versus females, respectively? 
  #The Y chromosome encodes the genes which are the most strongly upregulated in males.
  #The chromosomes which encode the genes most strongly upregulated in females vary more,
  #however. With the most upregulated genes on chromosomes 14, 16, and 21.
#Are there more male-upregulated genes or female-upregulated genes near the top of the list? 
  #There are far more male-upregulated genes in the top of the list, more consistently on a 
  #single (Y) chromosome. This is logical as a female does not have this chromosome, and Y
  #chromosome genes masculinize a developing organism.


#2.3.4 - Examine the results for the two genes (WASH7P and SLC25A47) that you had previously
#tested with the basic linear regression model in step 2.1. 
#Are the results broadly consistent?
  #For WASH7P, the p-value is now 0.45993482, which IS statistically significant, and
  #for SLC25A47, the p-value is 1.045432e-09, which still is statistically significant.

#2.4 - Analyze gene expression based on cause of death classification
res <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes") %>%
  as_tibble(rownames = "GENE_NAME")
res <- res %>%
  filter(!is.na(padj)) %>%
  arrange(padj)
res

res <- res %>%
  filter(padj < 0.1) %>%
  arrange(padj)
res
#How many genes are differentially expressed according to death classification 
#at a 10% FDR? Interpret this result in your own words.
  #There are 16,059 genes differentially expressed according to death classification.
  #I think it is logical that this would be greater than the number of genes differentially
  #expressed by sex, these individuals are not developing and so are not as disimilar
  #as male vs female embryos. Additionally, these differences in gene expression are 
  #likely contributing factors in their deaths.

#3 - Present the data
ggplot(data = res, aes(x = log2FoldChange, y = -log10(padj))) +
  geom_point(aes(color = (abs(log2FoldChange) > 1 & pvalue < 0.1))) +
  geom_text(data = res %>% filter(abs(log2FoldChange) > 1 & pvalue < 0.1),
            aes(x = log2FoldChange, y = -log10(padj) + 5, label = GENE_NAME), size = 1.5,) +
  theme_bw() +
  theme(legend.position = "none") +
  scale_color_manual(values = c("darkgray", "pink")) +
  labs(y = expression(-log[10]("p-value")), x = expression(log[2]("fold change")))
