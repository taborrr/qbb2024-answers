# d2-lunch Exercises
# 2024 09 04
# Tabor Roderiques

## Answer 1
### Tally the number of each gene_biotype in hg38-gene-metadata-feature.tsv. How many protein_coding genes are there? Pick one biotype you would want to learn more about and explain why.
-  `grep -v "gene_biotype" hg38-gene-metadata-feature.tsv | cut -f 7 | sort | uniq -c`
-  `grep -v "gene_biotype" hg38-gene-metadata-feature.tsv | cut -f 7 | sort | uniq -c | wc -l`
- there are 38 different gene_biotypes 19618 protein coding genes
-  "artifact", there are 9 artifacts and I am wondering what exactly this biotype means and how it was assessed
- 












# pushing to git
git add <your_file_name>
git commit -m "<message_describing_your_submission>"
git push