#load libraries
library(tidyr)
library(ggplot2)

#load data
gene_data <- read.csv("gene_data.txt")

#reshape data into long format
long_gene_data <- gene_data %>%
  pivot_longer(cols = c(nascentRNA, PCNA, ratio), 
               names_to = "Measurement", 
               values_to = "Value")

#create violin plots
ggplot(long_gene_data, aes(x = Gene, y = Value, fill = Measurement)) +
  geom_violin(trim = FALSE) +  
  facet_wrap(~ Measurement, scales = "free_y") + 
  theme_minimal() +  
  labs(title = "Violin Plots of nascentRNA, PCNA, and Log2 Ratio by Gene",
       x = "Gene", y = "Value") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
