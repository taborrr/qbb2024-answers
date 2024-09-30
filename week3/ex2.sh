#!/usr/bin/env bash

### Question 2.1 ###
## commented out the three following three code lines to avoid re-downloading and 
## re-indexing in subsequent bash script runs
wget https://hgdownload.cse.ucsc.edu/goldenPath/sacCer3/bigZips/sacCer3.fa.gz
gunzip sacCer3.fa.gz
bwa index sacCer3.fa
## count the times that > appears at the start of a line. Chromosomes start with > in fasta files
grep -c "^>" sacCer3.fa
grep "^>" sacCer3.fa
# there are 17 chromosomes (x-xvi) in this yeast genome including a mitochondrial chromosome

### Question 2.2 ###
# for each short read seq file, report the file, extract the basename, align, and write to a sam
for my_sample in A01_*.fastq
do
    echo ${my_sample}
    my_sample=$(basename ${my_sample} .fastq)
    bwa mem -t 4 -R "@RG\tID:${my_sample}\tSM:${my_sample}" sacCer3.fa ${my_sample}.fastq > ${my_sample}.sam
done
less -S A01_09.sam
grep -v "^@" A01_09.sam | wc -l
# 669548 read alignments are included in this sam file. 


### Question 2.3 ###
grab all the lines that dont start with an @ symbol, and filter out lines that dont ahve chr3 in the 3rd column, report number of lines
grep -v "^@" A01_09.sam | awk '$3 == "chrIII"' | wc -l
# 17815 alignments are to loci on chr3, which is 2.66% of the total alignments 


### Question 2.4 ###
# for loop, sorts using 4 cpu threads, outputs bam format, indexes the new bams
for my_sample in A01_*.sam
do
    my_sample=$(basename ${my_sample} .sam)
    samtools sort -@ 4 -O bam -o ${my_sample}.bam ${my_sample}.sam
    samtools index ${my_sample}.bam
done

# The estimated 4.17x coverage at each base seems to overestimate the observed coverage when looking through the reads and alignments. 
# Some positions have 8 reads overlapping but many more positions have 2,1, or even zero reads mapped to a position. This opinion is 
# based on the regions I was looking at, and thus is biased which could explain why 4.17x coverage does not seem accurate.


### Question 2.5 ###
# chrI:113113-113343 window allows clear observation of 3 SNPs. I am certain about this ChrI 113326 SNP despite only having two total reads 
# claiming (with high QV 35) that this is an SNP because the likelihood of two sequencing errors at different positions in a read both overlapping
# at the same reference position showing an SNP is very, very low. This is an SNP. A few lone bases in the reads with a low QV are very clearly
# sequencing errors. 


### Question 2.6 ###
# chrIV:825548-825931, provides for observing an SNP at position chrIV 825834. 
# This SNP does not fall within a gene but rather a non-coding region, however, it is located between two genes SCC2 and SAS4. 