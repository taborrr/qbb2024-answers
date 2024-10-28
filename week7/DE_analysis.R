# Tabor Roderiques
# Week 7 quant bio problem set



# Exercise 1
# Step 1.1
library(tidyverse)
library(broom)
library(DESeq2)
library(readr)

# set your working directory to where your data and output will be stored, and view files
setwd("~/qbb2024-answers/week7/")
list.files()

# load the gene expression counts
counts_df <- read_delim("gtex_whole_blood_counts_downsample.txt")
# move GENE_NAME column to rownames, so that the contents of the
# tibble is entirely numeric
counts_df <- column_to_rownames(counts_df, var = "GENE_NAME")
# look at first five rows
counts_df[1:5,]
# load the metadata
metadata_df <- read_delim("gtex_metadata_downsample.txt")
# move SUBJECT_IDs from the first column to rownames
metadata_df <- column_to_rownames(metadata_df, var = "SUBJECT_ID")
# look at first five rows
metadata_df[1:5,]

# Step 1.2
# check that the columns of the counts are identical and in the same order as the
# rows of the metadata
colnames(counts_df) == rownames(metadata_df)
table(colnames(counts_df) == rownames(metadata_df))
# create a DESeq object
dds <- DESeqDataSetFromMatrix(countData = counts_df,
                              colData = metadata_df,
                              design = ~ SEX + AGE + DTHHRDY)
# Step 1.3
# apply VST normalization
vsd <- vst(dds)

# apply and plot principal components
plotPCA(vsd, intgroup = "SEX")
pca_plotage <- plotPCA(vsd, intgroup = "AGE")
pca_plotage + 
  labs(color = "AGE Brackets") +
  theme_minimal() +                       
  theme(panel.border = element_blank()) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50")
pca_plotd <- plotPCA(vsd, intgroup = "DTHHRDY")
pca_plotd +
  labs(color = "Death Cause") +
  theme_minimal() +                       
  theme(panel.border = element_blank()) +
  geom_vline(xintercept = 0, linetype = "dashed", color = "gray50") +
  geom_hline(yintercept = 0, linetype = "dashed", color = "gray50")

# What proportion of variance in the gene expression data is explained by 
# each of the first two principal components? Which principal components appear 
# to be associated with which subject-level variables? Interpret these patterns 
# in your own words and record your answers as a comment in your code.
# Answer:
# 55% (48+7) of variance is explained by the first two principle components.
# With subject-level variables meaning age and sex, the PC2 (7% variance) is likely
# representing the variance in these two preditor variables; maybe age is less 
# implicated in PC2 and more implicated into PC1's variance as there are more
# darker (younger) dots on one side than the other. Conclusion was reached by
# process of elimination, where death type was largely explaining the PC1 variance
# which means that the other predictor variables likely explain the PC2. 


# Exercise 2
# Step 2.1
# extract the normalized expression data and bind to metadata
vsd_df <- assay(vsd) %>%
  t() %>%
  as_tibble()
vsd_df <- bind_cols(metadata_df, vsd_df)

# examine the distribution of expression for WASH7P gene
hist(vsd_df$WASH7P)

# apply multiple linear regression to WASH7P gene
lm(data = vsd_df, formula = WASH7P ~ DTHHRDY + AGE + SEX) %>%
  summary() %>%
  tidy()
# Question 2.1.1
# Does WASH7P show significant evidence of sex-differential expression 
# (and if so, in which direction)? Explain your answer.
# Answer:
# The 0.119 positive estimate for SEX (male) states there is an increase 
# in WASH7P expression in males, but that this effect is statistically 
# insignificant and thus unreliable for interpretation. WASH7P shows no 
# significant evidence of sex-differential expression, as the p-value 
# for SEX (male) is 0.279, extremely higher than the significance 
# threshold of  0.05.

lm(data = vsd_df, formula = SLC25A47 ~ DTHHRDY + AGE + SEX) %>%
  summary() %>%
  tidy()
# Question 2.1.2
# Now repeat your analysis for the gene SLC25A47. Does this gene show evidence 
# of sex-differential expression (and if so, in which direction)? Explain your answer.
# Answer:
# With a P value of 0.0257, there is a statistically significant sex-differential expression
# for the SLC25A47 gene where it states that males have a slight increase in this gene's 
# expression with a 0.518 positive estimate factor.

# Step 2.2
# use DESeq2 to perform differential expression analysis across all genes PROPERLY
dds <- DESeq(dds)

# Step 2.3
# Step 2.3.1
res <- results(dds, name = "SEX_male_vs_female")  %>%
  as_tibble(rownames = "GENE_NAME")
# Step 2.3.2
filt_res <- res %>%
  filter(!is.na(padj)) %>%
  filter(padj <= 0.1) %>% # 10% FDR
  arrange(padj)
# Question:
# How many genes exhibit significant differential expression between
# males and females at a 10% FDR?
# Answer:
# 262 genes exhibit significant DE between the two sexes.

# Step 2.3.3
gene_loc <- read_delim("gene_locations.txt", col_types = cols())
# Merge pasilla_res with gene_names by GENE_ID
chr_res <- filt_res %>%
  left_join(gene_loc, by = "GENE_NAME") %>%
  arrange(padj)
# Question:
# Which chromosomes encode the genes that are most strongly upregulated 
# in males versus females, respectively? Are there more male-upregulated 
# genes or female-upregulated genes near the top of the list?
# Answer:
# The top 11 padj DE genes are on Chromosome Y, and 20 of the top 26 padj DE genes 
# are on Chromosome Y with the other 6 DE genes on Chromosome Y. 
# Top 11 highest padj DE genes are male up-regulated and chromosome Y. There are 
# many more male-upregulated genes near the top of the list. This implies that
# genes not present in females are significantly more expressed in males as taken 
# autopsy samples. This is obvious, as it is expected Chr Y genes would be DE 
# and upregulated in males with XY compared to females with XX. 

# Step 2.3.4
dds_df <- assay(dds) %>%
  t() %>%
  as_tibble()
dds_df <- bind_cols(metadata_df, dds_df)
lm(data = dds_df, formula = WASH7P ~ DTHHRDY + AGE + SEX) %>%
  summary() %>%
  tidy()
lm(data = dds_df, formula = SLC25A47 ~ DTHHRDY + AGE + SEX) %>%
  summary() %>%
  tidy()
# Question:
# Are the results broadly consistent with WASH7P and SLC25A47 from before?
# Answer: 
# Yes, the results are broadly consistent but much more enhanced. WASH7P has
# an even more insignificant P-value than before, now its 0.896 instead of 0.279
# and for SLC25A47 the P-value is almost as statistically significant at 
# 0.0258 instead of 0.0257 but the sex-differential expression estimates 
# that males have a massive increase in this gene's expression with a 
# 22.3 positive estimate factor instead of 0.518 from before. 

# Step 2.4
# Step 2.4.1
res_death <- results(dds, name = "DTHHRDY_ventilator_case_vs_fast_death_of_natural_causes")  %>%
  as_tibble(rownames = "GENE_NAME")
filt_res_d <- res_death %>%
  filter(!is.na(padj)) %>%
  filter(padj <= 0.1) %>%
  arrange(padj)
# Question:
# How many genes exhibit significant differential expression between
# males and females at a 10% FDR?
# Answer:
# 16,069 genes exhibit significant DE between death styles.

# Step 2.4.2
# Question:
# Interpret this result in your own words. Given your previous analyses, 
# does it make sense that there would be more genes differentially 
# expressed based on type of death compared to the number of genes 
# differentially expressed according to sex?
# Answer: 
# Observing how there are 16,069 significant DE genes when comparing death styles
# versus observing 262 significant DE genes between the sexes, makes sense. This 
# is because the experiment data exclusively regards samples taken patients in two 
# specific groups: natural versus ventilator deaths. Although a couple hundred DE 
# genes occur between male and female categories, there are 60x more DE genes observed
# between the causes of death categories. It is not an experiment about the genetics 
# behind male or female, it is an experiment about the genetics behind natural or 
# ventilator deaths, with samples taken only in autopsys from those patients. Cause
# of death is the main variable and it makes sense it explains more of the variance
# and accounts for more of the DE genes by so much more. 


# Exercise 3
# Step 3.1
# create volcano plot
ggplot(data = filt_res, aes(x = log2FoldChange, y = -log10(pvalue))) +
  geom_point(aes(color = (abs(log2FoldChange) > 2 & pvalue < 1e-20))) +
  geom_text(data = filt_res %>% filter(abs(log2FoldChange) > 1 & pvalue < 1e-50),
            aes(x = log2FoldChange, y = -log10(pvalue) + 5, label = GENE_NAME), size = 3,) +
  geom_vline(xintercept = c(-2, 2), linetype = "dotted", color = "gray50") +
  geom_hline(yintercept = -log10(1e-20), linetype = "dotted", color = "gray50") +
  theme(
    panel.background = element_blank(),
    axis.line = element_line(color = "black", size = 0.5),  # Thin, black axis lines for visibility
    axis.title = element_text(face = "bold", size = 14),    # Bold axis titles for emphasis
    axis.text = element_text(size = 12),                    # Slightly smaller axis text
  ) +
  theme(legend.position = "none") +
  scale_color_manual(values = c("darkgray", "coral")) +
  labs(title = "Volcano Plot", y = expression(-log[10]("p-value")), x = expression(log[2]("fold change")))