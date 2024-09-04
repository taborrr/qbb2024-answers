# Day 1 Morning Assignment 
# 2024 09 03
# Tabor Roderiques

# libraries
library("tidyverse")

# PART 3
df <- read_tsv("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SampleAttributesDS.txt")
df <- df %>%
  mutate( SUBJECT=str_extract( SAMPID, "[^-]+-[^-]+" ), .before=1 )
View(df)

# Which two SUBJECTs have the most samples? The least?

# PART 4
## subject with least samples:
### GTEX-1JMI6 and GTEX-1PAR6 with 1 sample
df %>%
  group_by(SUBJECT) %>%
  summarize(sample_count=n()) %>%
  arrange(sample_count)

## subject with most samples:
### K-562 with 217 samples
df %>%
  group_by(SUBJECT) %>%
  summarize(sample_count=n()) %>%
  arrange(desc(sample_count)) #also works arrange(-sample_count)

# PART 5
# Which two SMTSDs (tissue types) have the most samples? The least? Why?

## tissue types with most samples
### whole blood with 3288 samples and Muscle - Skeletal with 1132 samples
df %>%
  group_by(SMTSD) %>%
  summarize(sample_count=n()) %>%
  arrange(desc(sample_count))

## tissue types with least samples
### Kidney - Medulla with 4 samples
### Cervix - Ectocervix and Fallopian Tube with 9 samples
df %>%
  group_by(SMTSD) %>%
  summarize(sample_count=n()) %>%
  arrange(sample_count)


# PART 6
# SUBJECT GTEX-NPJ8
df_npj8 <- df %>%
  filter(SUBJECT == "GTEX-NPJ8")

# which tissues have the most samples? why?
# white blood with 9 samples
# this is an easily accessible sample type to obtain
df_npj8 %>%
  group_by(SMTSD) %>%
  summarize(sample_count=n()) %>%
  arrange(-sample_count)

# what are sample differences between the Whole Blood
## the samples were explored with different assays,
## including for example, WES, RNASEQ, WGS
df_npj8_WB <- df_npj8 %>%
  filter(SMTSD == "Whole Blood")

View(df_npj8_WB)

# PART 7
# explore SMATSSCR (autolysis score)

df %>%
  filter( !is.na(SMATSSCR) )

# How many SUBJECTs have a mean SMATSSCR score of 0?
# 15 SUBJECTS have a mean SMATSSCR of 0
obsv_mn_smscr <- df %>%
  filter( !is.na(SMATSSCR) ) %>%
  group_by(SUBJECT) %>%
  summarize(mean_SMATSSCR = mean(SMATSSCR)) %>%
  group_by(mean_SMATSSCR) %>%
  summarize(counts_mean_smatsscr=n()) %>%
  arrange(mean_SMATSSCR)

View(obsv_mn_smscr)

# What other observations can you make about the distribution of mean scores?
## there are higher counts at the more rounded mean values like 0.5 1.0 
## which have 13 and 97 counts respectively

# What are possible ways to present this information in a report?
## a nice histogram would visualize the data better

# Just For Fun
# df_finale <- read.table("~/Data/GTEx/GTEx_Analysis_v8_Annotations_SubjectPhenotypesDD.xlsx")
# View(df_finale)













