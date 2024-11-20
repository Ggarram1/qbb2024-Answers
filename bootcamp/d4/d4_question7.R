library(tidyverse)
library(ggplot2)

#read in gene expression data

expression <- read_tsv(file = "~/qbb2024-Answers/d4/dicts_expr.tsv")
#expression <- read.delim("~/qbb2024-Answers/d4/dicts_expr.tsv", sep="\t")

#glimpse data
glimpse(expression)

#add new category w/ tissue and gene
expression
expression <- expression %>%
  mutate(Tissue_Gene=paste0(Tissue, " ", GeneID)) %>%
  mutate(log2_Expr = log2(Expr + 1))

#violin plot of expression data, by category

ggplot(data = expression, mapping = aes(x=Tissue_Gene, y=log2_Expr))+
  geom_violin()+
  labs(x="Tissue + Gene ID", y= "Log 2 Gene Expression")+
  coord_flip()