# day 4 lunch exercises

library(tidyverse)

# read the file
gtx_hits <- read_tsv(file = "~/qbb2024-answers/d4-morning/results_exercise7_full.tsv",
                     col_names = c("xdata", "geneID", "tissue"))


# transform the data
######## should we log2 or log10 transform???
data_transformed <- gtx_hits %>%
  mutate(
    log_xdata = log2(xdata + 1),  # log2-transform with pseudo-count of 1
    Tissue_Gene = paste0(tissue, " ", geneID)  # combine tissue and geneID
  )

# create the violin plot
ggplot(data_transformed, aes(x = Tissue_Gene, y = log_xdata)) +
  geom_violin() +
  coord_flip() +  # switch the axes
  labs(
    x = "Tissue and Gene ID",
    y = "Log-transformed Expression Levels"
  ) +
  ggtitle("Relationship between log2 transformed gene expression and tissue specific genes") 


# exercise 8 questions:
# Given the tissue specificity and high expression level of these genes, are you surprised by the results?
## If a gene known to be crucial for tissue specific function  shows high expression in that specific tissue, 
## it unsurprisingly matches up with the expectations. The observed high expression levels (log2 transformed) in 
## the specific tissues confirms that gene’s significant role in that specific tissue.

# What tissue-specific differences do you see in expression variability? 
# Speculate on why certain tissues show low variability while others show much higher expression variability.
## The tissues with more than one type of highly expressed gene include the 3 testis genes, 3 pituitary gland genes,
## and the 5 pancreas genes. Within these three tissues, although the highly expressed genes have similarly clustering
## expression levels, the variability is quite remarkable across the samples. 
## Testis gene violin densities are 11, 13, 14 tpm log10 +1 pseudocount expression level
## Pituitary genes are 12, 16, 16 expression levels
## Pancreas genes are 12, 12, 13, 14, 16 expression levels
## The Pituitary gland genes have the greatest expression variability from the violin reaching 
## from 0 to 18 expression levels. Ignoring one of the pancreas genes, the rest of the expression 
## variability range is from 8 to 16 expression levels. One pancreas gene happens to violin
## from 0 to 15 levels unlike the other highly expressed pancreas genes. Between the pancreas and 
## pituitary gland expression variability is the testis with a range from 4 to 15 expression levels.
## For the few highly expressed genes on the violin, a few tissues from across all the sampled individuals
## have low variability of expression levels. These lowest variability tissues include the pancreas genes 
## and a liver gene. Low variability may arise from the fact that these genes in these tissues may operate 
## on a very consistent baseline across the species even between time of day, season, gender, age, and 
## health status.These could be basal genes that are simply expressed at the same pace 24/7/365 and 
## explains why those tissues have low expression variability. 
## For the high expression variability, the basis for this can be that the tissues have specific gene 
## networks that fluctuate through those aforementioned variables (hour, season, gender, age, health
## status). Thus although the same sample tissue type, the tissue is at a different point in its 
## rhythm of function and has those same gene networks off or on, explaining the variability in
## expression for a few tissues. The pituitary gland has 2 highly expressed genes but also has
## the widest expression variability. This hormonal response tissue deals with countless variables
## on a day to day, hour to hour basis, which explains why a few highly expressed genes have wide
## expression variability across the samples. The minor salivary gland highly expressed gene on the
## violin plot further reinforces this concept that for tissues that regularly alter there outputs
## like saliva secretion, it would make sense that the sampled tissue have wide expression variability. 

 
