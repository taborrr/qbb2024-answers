# week 5 quantitative biology lab assignment
## Tabor Roderiques
## week starting Friday October 11th, 2024

# Exercise 1
# Step 1.1
# Click through the different metrics. Do any stand out as problematic? Remember that fastqc is meant for DNA sequences from across the genome. Can you think of a reason why this sample does not match the expected GC content distribution and base content at the beginning of sequences?
The median per base sequence quality is in the green phred zone for all 100 positions of the reads from both samples 1 and 2, but the box plots' lower quartiles do dip into the yellow phred zone at the 100bp position for sample 2. However, that is not of concern given that the forward strands from sample 1 which report the same reads but anti-parallel all have green phred scores in the 1-5bp positions, masking any problems from that reverse strand 100bp calls. 
What could account for the base content incongruency is a biased sampling where certain sequences were more frequently cleaved or primer-related errors where slightly non-specific primers amplified more frequently and became over represented in the initial 10bp base content. These ideas could also explain the additional lower GC content % peak in both samples. Contamination, only in reference to the per sequence GC content graph, could be a worthwhile explaination for the GC content extra-peak because it has fewer counts and is isolated to a peak. 

# Step 1.2
# What is the origin of the most overrepresented sequence in this sample? Does it make sense?
Enzymes that break down proteins rely on the catalytic triad pocket of serine proteases. These proteases are abundant in gut niches that break down protein rich food via proteolysis. The most overrepresented sequences in both samples were identical and BLAST matched them to serine protease sequence from drosophila. This makes sense given that these samples were collected from a specific part of the drosophila gut that likely functions to break down proteins from foods. 


# Exercise 2
# If you were to reject any samples with the percentage of unique reads less than 45%, how many samples would you keep?
Based on both FastQC of the raw and trimmed reads, every single sample (and every paired-end read) is at or below 35% unique reads, let alone 45% unique reads. All the samples would not be kept with this threshold. 
# Can you see the blocks of triplicates clearly? Try adjusting the min slider up. Does this suggest anything about consistency between replicates?
It took a second to understand, yet now I clearly distinguish the sample triplicates listed in order on the diagonal of the graph showing close similarity amongst every three samples, sometimes every six samples. Some triplicates are clearly than others, with the lower left quartile samples being the least consistent. On the whole, there is decent consistency between samples, with over half the depicted triplicates remarkably uniform in similarity based on differential expression analysis comparisons. What we can observe in this graph is a mostly clear 3x3 squares along the diagonal.



