#!/usr/bin/env bash

### Question 1.1 ###
# every 4 lines of code, look at the second, then print the length of the line starting from position 0, sort them by number, curate unique vals
awk 'NR % 4 == 2 {print length($0)}' A01_09.fastq | sort -n | uniq
# all the sequencing reads are 76 bases long within the A01_09.fastq file


### Question 1.2 ###
# for every 4 lines of code look at the first line (arbitrary), add 1 to the count (which starts from 0), at the end -> print the total count
awk 'NR % 4 == 1 {count++} END {print count}' A01_09.fastq
# there are 669548 reads present within the A01_09.fastq file


### Question 1.3 ###
# yeast genome is 12.2Mb (million)
# scale=5 assists decimal precision, output to bc for math
echo "scale=5; 76 * 669548 / 12200000" | bc
# the yeast genome coverage is 4.1709547540x which is bascially 4x average depth of coverage from short read sequencing


### Question 1.4 ###
du -m A01_* | sort -n
# Out of all the A_01*.fastq files, the A01_62.fastq file is the biggest with 149Mb of disk usage, and A01_27.fastq is the smallest file with 110Mb of du. 

### Question 1.5 ###
# output the html's to a subfolder called fastqc
fastqc -f fastq -o fastqc A01_*.fastq
# In the fastqc report html for A01_09, looking at the per base sequence quality box plots, 
# the red median line for each base position of the read indicates that the meadians are 
# either 35 or 36 quality scored, this value lies well over the 28 quality score green 
# zone on the graph. Assuming that the quality score is a Phred Score, these 35-36 Phred 
# show a low probability of sequence error. Because P = 10^(-Q/10), the Q=35/36 Phred scores
# for these reads in A1_09 have a probabiliy of error between 0.032% and 0.025% chance of being
# a sequencing error. The 25th, median, 75th, and 90th percentile of the median base quality 
# along the read is markedly identical, all falling within the green Phred score zone. However,
# understandibly the 10th percentile values are higher in the center of the sequencing reads and 
# symmetrically lower towards the ends of the reads. 