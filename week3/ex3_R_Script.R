# Week 3 Assignment 
# 2024 09 30
# Tabor Roderiques


library(tidyverse)
library(dplyr)


## question 3.1
### plot allele frequency spectrum distribution of the variants in the vcf
# read file into a table and give it a header
df <- read.table("~/qbb2024-answers/week3/AF.txt", header = FALSE)
colnames(df) <- c("AF")
# plot the af histogram
ggplot(data = df, mapping = aes(x = AF)) +
  geom_histogram(bins = 11, binwidth = 0.05, alpha = 0.7) +
  labs(title = "Histogram of Allele Frequency (AF)", x = "AF", y = "Count") +
  theme_minimal()
# This variant allele frequency spectrum displays a slightly right-skewed distribution suggesting 
# that it is a Poisson distribution. This seems to align with our understanding that variant alleles 
# are rarer and would have a low frequency because variants arise from random mutations and it is unlikely 
# for them to reach fixation at the highest frequency side of the histogram. However, despite more counts 
# in the lower frequency, there are still plenty higher-frequency variant alleles which can be explained 
# by how the samples come from 10 different ESTABLISHED wine yeast strains where their variants are 
# already seriously near fixation in their isolated populations. 



## question 3.2
dpf <- read.table("~/qbb2024-answers/week3/DP.txt", header = TRUE)
ggplot(data = dpf, mapping = aes(x = DP)) +
  geom_histogram(bins = 21, alpha = 0.7) +
  xlim(0, 20) +  # x-axis limits
  labs(title = "Read Depth Distribution for Each Variant Site for Each Sample", 
       x = "Read Depth at a Single Site", 
       y = "Count") +
  theme_minimal()
# The results of the Read Depth distribution are completely expected, and it revalidates the earlier 
# inference of 4.17x coverage at each position not isolating for variant sites. Although given the X-axis 
# length requirements do not show the 6887 positions with 0 read depth, we can infer from the graph that 
# many places in the sequencing alignment show no reads mapped, and expectedly, very few variant sites 
# have over 15 reads of depth. The most common read depths were the 3 to 5 bins which was expected given 
# that the expected coverage for each position was 4.17x as inferred from the total bp from reads divided 
# by the genome size. This distribution looks to be a right skewed poisson distribution. 


