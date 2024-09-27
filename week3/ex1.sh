#!/usr/bin/env bash

### Question 1.1 ###
# every 4 lines of code, look at the second, then print the length of the line starting from position 0, sort them by number, curate unique vals
awk 'NR % 4 == 2 {print length($0)}' A01_09.fastq | sort -n | uniq
# all the sequencing reads are 76 bases long within the A01_09.fastq file


### Question 1.2 ###
# for every 4 lines of code look at the first line (arbitrary), add 1 to the count (which starts at 0), at the end print the total count
awk 'NR % 4 == 1 {count++} END {print count}' A01_09.fastq
# there are 669548 reads present within the A01_09.fastq file


### Question 1.3 ###
# yeast genome is 12.2Mb (million)
# scale=5 assists decimal precision, output to bc for math
echo "scale=5; 76 * 669548 / 12200000" | bc
# the yeast genome coverage is 4.1709547540x which is bascially 4x average depth of coverage from this small read sequencing



### Question 1.4 ###
echo "76 * 669548 / 12200000000" | bc
my unix commands | to perform | Q1.2 analysis here
# A written answer to Question 1.2 based on the output of my code above can go here here.

### Question 1.5 ###
my unix commands | to perform | Q1.2 analysis here
# A written answer to Question 1.2 based on the output of my code above can go here here.