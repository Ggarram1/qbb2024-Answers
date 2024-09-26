# Load necessary libraries
library(ggplot2)
library(dplyr)

#Load the data
output_file <- "qbb2024-Answers/Week 2/snp_density_enrichment.txt" 
# Read the data
data <- read.table(output_file, header = TRUE, sep = "\t", stringsAsFactors = FALSE)

#Transform data
data$Density_Enrichment <- as.numeric(as.character(data$Density_Enrichment))
data$Density_Enrichment[data$Density_Enrichment == 0] <- NA
data <- data %>%
  mutate(Log2_Enrichment = log2(Density_Enrichment))
#Remove rows with NA values in Log2_Enrichment before plotting
data <- na.omit(data)

#Create the plot
ggplot(data, aes(x = as.factor(MAF), y = Log2_Enrichment, color = Feature_Type, group = Feature_Type)) +
  geom_line(size = 1) + 
  geom_point(size = 2) +
  labs(
    title = "SNP Density Enrichment by MAF and Feature Type",
    x = "Minor Allele Frequency (MAF)",
    y = "Log2-transformed Density Enrichment",
    color = "Feature Type"
  ) +
  theme_minimal() +
  theme(
    legend.position = "top",
    plot.title = element_text(hjust = 0.5)
  )

#Save the plot
ggsave("snp_density_enrichment_plot.png", width = 8, height = 6)
