# Day 1 Afternoon Assignment 
# 2024 09 03
# Tabor Roderiques

#libraries
library(tidyverse)


#Q1
df <- read_delim("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")

#Q2
df
glimpse(df)

#Q3
RNA_seq_subset_df <- df %>%
  filter(SMGEBTCHT == "TruSeq.v1")

#Q4
# plot the number of samples from each tissue
# tissue_v_samples_df <- df %>%
#   group_by(SMTSD) %>%
#   summarize(sample_count=n()) %>%
#   arrange(desc(sample_count))
ggplot(data=RNA_seq_subset_df, 
       mapping = aes(x = factor(SMTSD))) +
  geom_bar() +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust=1)) +
  xlab("TIssue Types") +
  ylab("Count") +
  ggtitle("Relationship between Tissue Type and Sample Count")

#Q5
ggplot(data=RNA_seq_subset_df, 
       mapping = aes(x = SMRIN)) +
  geom_histogram() +
  xlab("RNA Integrity Number") +
  ylab("Count") +
  ggtitle("Relationship between RIN and their Counts")
## a simple histogram to see distribution from the range of RINs
## the distribution is unimodal around RIN=7

#Q6
ggplot(data=RNA_seq_subset_df, 
       mapping = aes(x = SMRIN, fill=SMTSD)) +
  geom_bar() +
  scale_color_solarized() +
  xlab("RNA Integrity Number") +
  ylab("Count") +
  ggtitle("Relationship between RIN and their Counts within Tissues")
## a barplot to see distribution but also to overlay
## with tissue type.
## between tissues, the counts of RIN for each sample are 
## uniform.
## brain spinal cord tissue sample's RIN have high counts 
## at a highly intact RIN=10 compared to other tissues
## making it an outlier. 
## Why spinal cord RNA might have higher quality RNA isolated
## may be because this suborgan of the nervous system has
## stronger research force that have made a significantly
## more efficacious RNA isolation protocol. In terms of
## biology, and possibly the more accurate explaination,
## spinal cord tissue may simply create highly stabilized
## long lasting RNAs in order for this suborgan to function.


#Q7
ggplot(data=RNA_seq_subset_df, 
       mapping = aes(x = SMGNSDTC, fill=SMTSD)) +
  geom_histogram() +
  scale_color_solarized() +
  # xlab("Genes Detected") +
  # ylab("Samples") +
  ggtitle("Relationship between Genes Detected and Tissues from Samples")

ggplot(data=RNA_seq_subset_df, 
       mapping = aes(x = SMGNSDTC, fill=SMTSD)) +
  geom_histogram() +
  scale_color_solarized() +
  # xlab("Genes Detected") +
  # ylab("Samples") +
  ggtitle("Relationship between Genes Detected and Tissues") +
  facet_wrap("SMTSD", scales = "free_y") + 
  theme(legend.position = "none")

## All of the distributions are unimodal, but there are a range 
## of sample abundances which correlate with ease of experimental
## acquisition techniques as well as size of organs.
## The testis having expressed a high number of different genes 
## explains why the testis in the graph have a decent number of 
## samples with a higher number of genes detected above 30,000.



#Q8
ggplot(data=RNA_seq_subset_df, 
       mapping = aes(x = SMTSISCH, y = SMRIN)) +
  geom_point(size = 0.5, alpha = 0.5) +
  geom_smooth(method = "lm") +
  xlab("Ischemic Time") +
  ylab("RNA Integrity Number") +
  ggtitle("Relationship between RIN and Sampling Time") +
  facet_wrap("SMTSD")
## Earlier the sampling occurred, the higher the RINs. There are more
## samples assessed earlier in time. The RIN quality does not correlate
## with Ischemic Time for a certain few tissue types including:
## skin, nervous system, and cell cultures. 

#Q9
ggplot(data=RNA_seq_subset_df, 
       mapping = aes(x = SMTSISCH, y = SMRIN)) +
  geom_point(size = 0.5, alpha = 0.5, aes(color = SMATSSCR)) +
  geom_smooth(method = "lm") +
  xlab("Ischemic Time") +
  ylab("RNA Integrity Number") +
  ggtitle("Relationship between RIN and Sampling Time") +
  facet_wrap("SMTSD")
## Quite Ischemic Time dependent, where the earlier in time sampling
## occurred the less autolysis occurred. But, again, a few tissue 
## types ignore this correlation including nervous system, cell
## cultures, and now adipose tissue. This suggests these tissue
## types are not strongly autolytic upon tissue extraction. This
## makes intuitive sense with the nervous system and cell cultures.
