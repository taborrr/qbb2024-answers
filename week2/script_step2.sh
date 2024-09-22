#!/bin/bash

# step 2.1

# make file with informative header line for the column contents
echo -e "MAF\tFeature\tEnrichment" > snp_counts.txt

# Loop through each possible MAF value
for i in 0.5 0.4 0.3 0.2 0.1
do
    # Use the MAF value to get the file name for the SNP MAF file
    snpf=chr1_snps_${i}.bed
    # Find the SNP coverage of the whole chromosome
    bedtools coverage -a genome_chr1.bed -b ${snpf} > all_chr1_maf${i}.txt
    # Sum SNPs from coverage of chr1
    sum1=$(awk '{a+=$4}END{print a}' all_chr1_maf${i}.txt)
    # Sum total bases from chr1
    sum2=$(awk '{b+=$6}END{print b}' all_chr1_maf${i}.txt)
    # Calculate the background ratio
    backg=$(bc -l -e "${sum1} / ${sum2}")
    # Loop through features
    for j in cCREs exons introns other # genes_chr1.bed is accounted for
    do
        # file into a variable
        feat=${j}_chr1.bed
        # SNP coverage of this feeture
        bedtools coverage -a ${feat} -b ${snpf} > maf${i}_${j}_cov.txt
        # Sum SNPs from coverage of feat
        sum3=$(awk '{a+=$4}END{print a}' maf${i}_${j}_cov.txt)
        # Sum total bases from feat
        sum4=$(awk '{b+=$6}END{print b}' maf${i}_${j}_cov.txt)
        # Calculate the snp feat ratio
        rayshio=$(bc -l -e "${sum3} / ${sum4}")
        # calculate normalized enrichment of each feature snp density for each MAF level
        nrich=$(bc -l -e "${rayshio} / ${backg}")
        # plop into next line (automatically) of the results file
        echo -e "${i}\t${j}\t${nrich}" >> snp_counts.txt
        # update terminal runner
        echo -e "Done with the ${j} feature of the ${i} maf level\n"
    done
    echo -e "Done with the ${i} maf level for all features\n"
done
echo -e "Completely Done with all features and mafs"