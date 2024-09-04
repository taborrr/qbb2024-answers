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




# pushing to git
-  `command` + `s` in VS Code
- `git add /Users/cmdb/qbb2024-answers/d2-lunch/README.md` in CMD thereafter
- `git commit -m "update to day 2 lunch exercises"` 
- `git push`