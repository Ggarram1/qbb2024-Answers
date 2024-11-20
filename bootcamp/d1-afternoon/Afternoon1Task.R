#1: first, the tidyverse package must be loaded, then the metadata is read.
library(tidyverse)
df<- read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
#this opens the data file in R and renames this data set.

#2: As the data set is very large, the data cannot be viewed fully in the console.
#for this reason, we will use the glimpse function.
glimpse(df)

#3:To analyze only the RNA-seq data, the df is filtered.
df_filter <- filter(df, SMGEBTCHT=="TruSeq.v1")
#This isolates all data where the SMGEBTCHT sequencing method is TruSeq.v1.

#4:to plot, and make understandable, the data, these conditions should be specified.
ggplot(df_filter, mapping = aes (x=SMTSD), scale_x_reverse())+
  scale_fill_colorblind()+
  geom_bar()+
  xlab("Tissue Type")+
  ylab("Number of Samples")+
  ggtitle("Number of Samples per Tissue Type")+
  theme(axis.text.x=element_text(angle=90, hjust = 1, vjust = 0.5))

#5:to investigate RNA integrity across samples, the filtered data will be 
#plotted.
ggplot(df_filter, mapping = aes (x=SMRIN))+
  scale_fill_colorblind()+
  geom_histogram()+
  ylab("Tissue Type")+
  xlab("RNA Integrity")+
  ggtitle("RNA Integrity across Tissue Types")
#this is a unimodal distribution with right skew.

#6:In #5, the tissue types were combined. Separating them allows for a different analysis 
#of RNA integrity depending on tissue type.
ggplot(df_filter, mapping = aes (y=SMRIN,x=SMTSD))+
scale_fill_colorblind()+
  geom_boxplot()+
  ylab("RNA Integrity")+
  xlab("Tissue Type")+
  ggtitle("RNA Integrity by Tissue Type")+
  theme(axis.text.x=element_text(angle=90, hjust = 1, vjust = 0.5))
#Although the majority of tissues have similar levels of RNA Integrity, there are certain
#outliers. The tissue with the most consistent RNA integrity is a leukemia cell line.
#Of the tissues, coronary and tibial arterial tissues, as well as spleen and non-
#sun-exposed skin. One possible reason for this is that rapid RNA degradation in 
#these could be evolutionarily disadvantages - especially in the cardiac tissues.

#7:To analyze gene expression by tissue, the number of genes detected will be plotted
#against the tissue type
ggplot(df_filter, mapping = aes (x=SMGNSDTC, y=SMTSD))+
  scale_fill_colorblind()+
  geom_point()+  
  ylab("Tissue Type")+
  xlab("Genes Detected")+
  ggtitle("Genes Detected per Sample")+
  theme(axis.text.x=element_text(angle=90, hjust = 1, vjust = 0.5))+
  theme(text = element_text(size = 8))
#Again, the majority of tissues have a similar number of genes that have been detected.
#However, there are both high and low outliers. In particular, the leukemia cell line 
#had the fewest genes detected. Contrarily, the most genes were identified in 
#testis tissue.

#8:To better understand the effect of ischemic time on RNA integrity, the data must
#be separated by tissue type, to reduce confounding variables.
ggplot (df_filter, mapping=aes (x=SMTSISCH, y=SMRIN))+
  geom_point(size = 0.5) + 
  geom_smooth(method="lm")+
  facet_wrap(~SMTSD)+
  scale_color_colorblind()+
  xlab("Total Ischemic Time (m)")+
  ylab("RNA Integrity")+
  ggtitle("RNA Integrity depending on Total Ischemic Time")
#There is substantial variation across tissues. In certain tissues, the range of
#RNA integrity does not seem to be influenced by ischemic time - notably cervical
#tissues and kidney.

#9:To further analyze the data, the autolysis measure should also be considered.
ggplot(df_filter, mapping=aes(x=SMTSISCH, y=SMRIN))+
  geom_point(size = 0.5, mapping = aes(color=SMATSSCR)) + 
  geom_smooth(method="lm")+
  facet_wrap(~SMTSD)+
  xlab("Total Ischemic Time (m)")+
  ylab("RNA Integrity")+
  ggtitle("RNA Integrity depending on Total Ischemic Time")
#This analysis allows us to observe the SMATSSCR variation within tissue types, 
#with the data already organized by RNA integrity. It can be observed that the SMARSSCR
#is often lower in samples with lower RNA integrity, and vice versa. However,
#this is very tissue dependent where tissues adrenal gland tissue clearly shows 
#this patterns while there is minimal variation in RNA integrity in the tibial nerve
#tissue or sun-exposed skin.

#10: I very much did not finish early D:
 

