# d2-lunch Exercises
# 2024 09 04
# Tabor Roderiques


# BioMart Questions
## Answer 1
### Tally the number of each gene_biotype in hg38-gene-metadata-feature.tsv. How many protein_coding genes are there? Pick one biotype you would want to learn more about and explain why.
-  `grep -v "gene_biotype" hg38-gene-metadata-feature.tsv | cut -f 7 | sort | uniq -c`
-  `grep -v "gene_biotype" hg38-gene-metadata-feature.tsv | cut -f 7 | sort | uniq -c | wc -l`
- there are 38 different gene_biotypes 19618 protein coding genes
-  "artifact", there are 9 artifacts and I am wondering what exactly this biotype means and how it was assessed


## Answer 2
### Which ensembl_gene_id in hg38-gene-metadata-go.tsv has the most go_ids? Create a new file that only contains rows corresponding to that gene_id, sorting the rows according to the name_1006 column. Describe what you think this gene does based on the GO terms.

- `head hg38-gene-metadata-go.tsv`
- `sort -k 1 hg38-gene-metadata-go.tsv | cut -f 1 | uniq -c | sort -k 1`
- ENSG00000168036 gene ID has the most GO IDs with a total of 273 GO IDs
- `grep "ENSG00000168036" hg38-gene-metadata-go.tsv | head`
- `grep "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -k 3 | head`
- this was to veryify that the column `name_1006` is sorted alphanumerically
- `grep "ENSG00000168036" hg38-gene-metadata-go.tsv | sort -k 3 > ../d2-lunch/ENSG00000168036_GO_sorted.tsv`
- the new file is satisfactory besides the missing column titles, which are not present anymore
- `head -n 100 ENSG00000168036_GO_sorted.tsv`
- skimming through the 273 GO terms, the diversity of ontological roles may suggest ENSG00000168036 gene ID is a basal transcription factor or simply a regulator of many upstream genes throughout an organism's function. This can explain the ostensibly disjoint roles it performs as identified in its GO annotation. 



# GENCODE Questions
## Answer 1
### Immunoglobin (Ig) genes are present in over 200 copies throughout the human genome. How many IG genes (not pseudogenes) are present on each chromosome? You can use a dot (.) in a regular expression pattern to match any single character. How does this compare with the distribution of IG pseudogenes?
- `grep "IG_._gene" gene.gtf | wc -l`
- there are 214 instances of IG genes
- `grep "IG_._gene" gene.gtf | sort -k 1 | cut -f 1 | uniq -c`
- these chromosomes have a specified number of IG Genes listed below
- chr21 has 1
- chr16 has 6
- chr15 has 16 
- chr22 has 48
- chr2 has 52
- chr14 has 91
- `grep "IG_._pseudogene" gene.gtf | sort -k 1 | cut -f 1 | uniq -c | sort -k 1`
- the pseudogene of IG gene counts on the specified chromosome are listed below
- 1 chr1
- 1 chr10
- 1 chr18
- 1 chr8
- 5 chr9
- 6 chr15 *can compare*
- 8 chr16 *can compare*
- 45 chr2 *can compare*
- 48 chr22 *can compare*
- 83 chr14 *can compare*
- there is a noticable similarity in IG and pseudogenes counts on the same chromosomes. so not only do the same chromosomes appear with IG and psdo genes but their abundance is also equivalent on each chromosome

## Answer 2
## Why is grep pseudogene gene.gtf not an effective way to identify lines where the gene_type key-value pair is a pseudogene (hint: look for overlaps_pseudogene)? What would be a better pattern? Describe it in words if you are having trouble with the regular expression.

- this search term although will successfully identify istances of "pseudogene", it will fail to only identify and filter for whole-term instances of "pseudogene" and will include other terms where "pseudogene" exists within them like "unprocessed_pseudogene" and "overlaps_pseudogene". 
- for a better pattern, use
- `grep "IG_._pseudogene" gene.gtf`
- no issues were encountered, but to help organize the results, you could include `| sort -k 1` to see any chromosomal patterns more clearly

## Answer 3
## Convert the annotation from .gtf format to .bed format. Specifically, print out just the chromosome, start, stop, and gene_name. As cut splits lines into fields based on the tab character, first use sed to create a new file where spaces are replaced with tabs.
- `sed "s/ /\t/g" gene.gtf > gene-tabs.gtf`
- `cut -f 1,4,5,10 gene-tabs.gtf > gene-tabs.bed`
- `head gene-tabs.bed`








# pushing to git
-  `command` + `s` in VS Code
- `git add /Users/cmdb/qbb2024-answers/d2-lunch/README.md` in CMD thereafter
- `git commit -m "update to day 2 lunch exercises"` 
- `git push`