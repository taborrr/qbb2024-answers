# Week 2 Assignment 
# 2024 09 20 - 09 26
# Tabor Roderiques

# libraries
library(tidyverse)
library(dplyr)
install.packages("devtools")
devtools::install_github("kevinsblake/NatParksPalettes")
library(NatParksPalettes)
names(NatParksPalettes)


# read in snp count enrichments
df <- read.table("~/qbb2024-answers/week2/snp_counts.txt", header = TRUE)
df <- df %>% 
  dplyr::mutate(log2Enrichment = log2(Enrichment))
# Choose a palette from NatParksPalettes (e.g., "Acadia")
palette <- natparks.pals("Chamonix", length(unique(df$Feature)))


# plot the snps vs maf levels
ggplot(data = df, mapping = aes(x = MAF, y = log2Enrichment, color = Feature)) +
  geom_line(aes(group = Feature)) +
  scale_color_manual(values = palette) +
  theme_minimal() +
  labs(title = "SNP Enrichment across MAF Levels for Different Genomic Features", 
       x = "Minor Allele Frequency", 
       y = "Log2 Normalized Enrichment)")
  