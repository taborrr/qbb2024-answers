# Quant Bio Lab 
# Week 8 - Home Work
# 2024 November 1st
# Tabor Roderiques

### 1. Load Data
# Libraries
library(tidyverse)
library(dplyr)
library(glue)
library(zellkonverter)
library(ggplot2)
library(scuttle)
library(scater)
library(scran)

setwd("/Users/cmdb/qbb2024-answers/week8")
gut <- readH5AD("v2_fca_biohub_gut_10x_raw.h5ad")
assayNames(gut) <- "counts"
gut <- logNormCounts(gut)
gut

# question 1
## genes = 12,407
## cells = 11,788
## dimension reduction preset datasets = X_pca X_tsne X_umap


# cell metadata
head ( colData(gut) )
colnames(colData(gut))
# Principal component analysis
set.seed(1234) # Set seed for reproducibility
plotReducedDim( gut, "X_umap", colour_by="broad_annotation" )

# question 2
## columns = 39
## three interesting columns = tissue, id, log_n_counts. These 3 columns would be able to reveal the most complete picture of the data, the expressed transcript normalized counts  for a specific gene ID in a specific gut Tissue. I am not sure what other information would be more important than these 3. 



### 2. Explore Data
genecounts <- rowSums(assay(gut))
summary( genecounts )
hist(genecounts)
head( sort(genecounts, decreasing=TRUE ) )

# question 3
## mean counts of a gene's expression across all cells= 3185. median = 254. This suggests the majority of transcripts are lowly expressed in each of the cells, but a few specific transcripts are extremely highly expressed, skewing the mean larger than the median.
## Top 3 highly expressed genes = lncRNA:Hsromega, pre-rRNA:CR45845, lncRNA:roX1. these are all non-coding RNAs, fairly long in sequence with two lnc RNAs. They are not transcribed into proteins (non-coding) as mentioned before, which is unexpected. Maybe this relates to how in most circumstances there is more protein than its mRNA because one mRNA can be translated multiple times (polyribosome) so for non-coding RNAs they are transcribed more. 


cellcounts <- colSums(assay(gut))
hist(cellcounts)
summary( cellcounts )
head( sort(cellcounts, decreasing=TRUE ) )
# question 4a
## mean number of counts per cell (mean total number of transcripts per cell)= 3622
## cells with >10,000 transcripts including the same or different genes may not be a fully differentiated cell, it could be cells in interphase and not in mitosis when nascent transcription is temporarily ceased in order to compact DNA into chromosomes. Or perhaps this cell type was collected at its peak utility in the tissue, at a time when this differentiated cell type had many of its gene networks activated to generate the cell type specific response that the organism needed in that tissue, which in this case could be transcripts to produce proteins related to digesting the food in the gut. 


celldetected <- colSums(assay(gut)>0)
hist(celldetected)
summary( celldetected )
(1059/12407) * 100
head( sort(celldetected, decreasing=TRUE ) )
# question 4a
## mean number of genes detected per cell (mean transcript diversity per cell) = 1059
## 8.5355 % is the mean of different genes expressed across cells per cell, a fraction of the 12,407 total different genes measured in this data set.


mito <- grep("^mt:", rownames(gut), value = TRUE)
df <- perCellQCMetrics(gut, subsets = list(Mito = mito))
summary(as.data.frame(df))
#> summary(as.data.frame(df))
# sum           detected  
# Min.   :  500   Min.   : 221     
# 1st Qu.: 1175   1st Qu.: 595    
# Median : 2006   Median : 841        
### Mean   : 3622   Mean   :1059 ###      
# 3rd Qu.: 3922   3rd Qu.:1300      
# Max.   :56357   Max.   :5086   
colData(gut) <- cbind( colData(gut), df )
plotColData(gut, y = "subsets_Mito_percent", x = "broad_annotation") +
  theme(axis.text.x = element_text(angle = 90))
# question 5
## enteroendocrine cell, epithelial cell, gut cell, muscle system all have higher percentage of mitochondrial reads. This may be because of the fact that these cell types are in highly active state to digest food requiring ATP to activate the production and function of digestive enzymes, secretion of these proteins, absorption of digested nutrients, all of which are energy dependent and explain why their mitochondrial genes are highly expressed compared to other cell types related to the gut. 


### 3. Identify Marker Genes
# question 6a
coi <- colData(gut)$broad_annotation == "epithelial cell"
epi <- gut[,coi]
plotReducedDim( epi, "X_umap", colour_by="annotation" )
marker.info <- scoreMarkers( epi, colData(epi)$annotation )
chosen <- marker.info[["enterocyte of anterior adult midgut epithelium"]]
ordered <- chosen[order(chosen$mean.AUC, decreasing=TRUE),]
head(ordered[,10]) # head(ordered[,1:10]) also works. head(ordered[,1:4]) this doesn't show you the column mean.AUC to allow you to see for yourself that it is actually in descending order
# question 6b
## Mal-A6, Men-b, vnd, betaTry, Mal-A1, Nhe2: are the top marker genes in the anterior midgut
## Most of the top 6 genes in the anterior midgut act as maltose metabolizers to convert maltose into glucose. The genes function in carbohydrate metabolic processes, malate-dehydrogenase for glucose homeostasis, TFs, putative digestive enzyme highly enriched in the midgut, maltase and glucosidase activity, and Na/H exchanger. All these suggest maltose metabolism is highly relevant to these cells in the midgut niche.
plotExpression(gut, "Mal-A6", x="annotation" ) +
  theme(axis.text.x = element_text(angle = 90))


# analyze somatic precursor cells
coi2 <- colData(gut)$broad_annotation == "somatic precursor cell"
som <- gut[,coi2]
plotReducedDim( som, "X_umap", colour_by="annotation" )
marker.info <- scoreMarkers( som, colData(som)$annotation )
chosen <- marker.info[["intestinal stem cell"]]
ordered <- chosen[order(chosen$mean.AUC, decreasing=TRUE),]
head(ordered[,10])
goi <- rownames(ordered)[1:6]
plotExpression(gut, features = goi, x="annotation") + 
  theme(axis.text.x = element_text(angle = 90))
# question 7
## enteroblast and intestinal stem cell have high similarity in normalized expression across these 6 makers.
## The gene marker called "Dl" has only 1 major expression peak in the intestinal stem cell type, while the other markers share high expression patterns amongst other cell types, making "Dl" seemingly most specific for intestinal stem cells, at least among these 6 markers. 