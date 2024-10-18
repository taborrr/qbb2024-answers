# Week 5 R script
# Tabor Roderiques

# Exercise 3

# Step 3.1
# library 
library(DESeq2)
library(vsn)
library(matrixStats)
library(readr)
library(dplyr)
library(tibble)
library(ggfortify)
library(hexbin)
sessionInfo()

# get data opened and named
setwd("/Users/cmdb/qbb2024-answers/week5")
data = readr::read_tsv("livecoding/salmon.merged.gene_counts.tsv")
data = column_to_rownames(data, var="gene_name")

# remove redundancy (row names and column 1)
data = data %>% dplyr::select(-gene_id)

# convert numbers to integers
data = data %>% dplyr::mutate_if(is.numeric, as.integer)

# filter out genes with low expression
data = data[rowSums(data) > 100, ]

# select narrow region samples
narrow = data %>% dplyr::select("A1_Rep1":"P2-4_Rep3")
dim(narrow)
colnames(narrow)


# Step 3.2
# creating metadata for proper naming 
metadata = tibble(tissue=as.factor(c("A1", "A1", "A1", 
                           "A2-3", "A2-3", "A2-3", 
                           "Cu", "Cu", "Cu", 
                           "LFC-Fe", "LFC-Fe", "Fe",
                           "LFC-Fe", "Fe", "Fe", 
                           "P1", "P1", "P1", 
                           "P2-4", "P2-4", "P2-4")),
                  rep=as.factor(c("Rep1", "Rep2", "Rep3",
                        "Rep1", "Rep2", "Rep3",
                        "Rep1", "Rep2", "Rep3",
                        "Rep1", "Rep2", "Rep1",
                        "Rep3", "Rep2", "Rep3",
                        "Rep1", "Rep2", "Rep3",
                        "Rep1", "Rep2", "Rep3")))

# creating DESeq2 model
ddsNarrow = DESeqDataSetFromMatrix(countData=narrow,
                                  colData=metadata,
                                  design=~tissue)

# apply VST, variance stabilizing transformation to improve variance explanation visualization
vstNarrow = vst(ddsNarrow)
meanSdPlot(assay(vstNarrow))


# Step 3.3
# PCA analysis and plotting
pca_data = plotPCA(vstNarrow, intgroup=c("rep","tissue"), returnData=TRUE)
ggplot(pca_data, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5) +
  theme_minimal() +
  ggtitle("PCA Plot of RNA-Seq data from replicate samples throughout the Drosophila midgut")


# restore the correct column names after mislabeling
colnames(narrow)[colnames(narrow) == "Fe_Rep1"] <- "Temp_Name"
colnames(narrow)[colnames(narrow) == "LFC-Fe_Rep3"] <- "Fe_Rep1"
colnames(narrow)[colnames(narrow) == "Temp_Name"] <- "LFC-Fe_Rep3"
# rerunning vst, mean, PCA plotting


# Step 3.4
# filtering genes by variance, keeping highly variant (Sd > 1)
matNarrow = as.matrix(assay(vstNarrow))
combined = matNarrow[,seq(1,21,3)]
combined = combined + matNarrow[,seq(2,21,3)]
combined = combined + matNarrow[,seq(3,21,3)]
combined = combined / 3
filt = rowSds(combined) > 1
matNarrow = matNarrow[filt,]


# Step 3.5
# k-mean clustering of genes
set.seed(42)
k = kmeans(matNarrow, centers=12)$cluster
# reorder data to bring members of clusters into their same cluster
ordering = order(k)
k = k[ordering]
matNarrow = matNarrow[ordering,]
heatmap(matNarrow, Rowv=NA, Colv=NA, RowSideColors=RColorBrewer::brewer.pal(12, "Paired")[k])


# Step 3.6
# gene ontology and enrichment analysis
genes = rownames(matNarrow[k==1,])

write.table(genes, 'cluster1.txt', sep="\n", quote=FALSE, row.names=FALSE, col.names=FALSE)






######## paused here


# log transform of data
logNarrow = normTransform(ddsNarrow)

# look at log mean by variance
meanSdPlot(assay(logNarrow))

# Apply VST, variance stabilizing transform to improve variance explantion visualizatino
vstNarrow = vst(ddsNarrow)
meanSdPlot(assay(vstBroad))


# Perform PCA
logPCAdata = plotPCA(logBroad, intgroup=c('rep', 'tissue'), returnData=TRUE)
ggplot(logPCAdata, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)

# Perform PCA
vstPCAdata = plotPCA(vstBroad, intgroup=c('rep', 'tissue'), returnData=TRUE)
ggplot(vstPCAdata, aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)


matBroad = as.matrix(assay(vstBroad))
combined = matBroad[,seq(1,9,3)]
combined = combined + matBroad[,seq(2,9,3)]
combined = combined + matBroad[,seq(3,9,3)]
combined = combined / 3

filt = rowSds(combined) > 1
sum(filt)

matBroad = matBroad[filt,]

# we dont want hierarchical agglomeric clustering
heatmap(matBroad)

heatmap(matBroad, Colv=NA)


# k-mean
set.seed(42)
k = kmeans(matBroad, centers=12)$cluster
# reorder data to bring memebrs of a clusters into their same cluster
ordering = order(k)
k = k[ordering]
matBroad = matBroad[ordering,]
heatmap(matBroad, Rowv=NA, Colv=NA, RowSideColors=RColorBrewer::brewer.pal(12, "Paired")[k])

genes = rownames(matBroad[k==2,])

write.table(genes,'cluster2.txt',sep="\n",quote=FALSE,row.names=FALSE,col.names=FALSE)

# go to terminal and output gene names
# go to homework assingment, open link for PANTHER
# insert genes into panther
# biological function
# molecular analysis
# 








