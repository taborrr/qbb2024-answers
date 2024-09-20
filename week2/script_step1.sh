#!/bin/bash

# step 1.4
# Loop through all files that match the pattern GenCodev46_chr1_*
for input_file in $(ls GenCodev46_chr1_*); do
    # Extract the base name without the "GenCodev46_chr1_" prefix and use it for the output file
    base_name=$(echo $input_file | sed 's/GenCodev46_chr1_//')
    
    # Define the output file
    output_file="${base_name%.txt}_chr1.bed"
    
    # Sort and merge using bedtools
    echo "Processing $input_file..."
    bedtools sort -i $input_file | bedtools merge > $output_file
    echo "Output written to $output_file"
done

echo "All tasks completed!"

# step 1.5
bedtools subtract -a genes_chr1.bed -b exons_chr1.bed > introns_chr1.bed

# step 1.6
bedtools subtract -a genome_chr1.bed -b exons_chr1.bed introns_chr1.bed cCREs_chr1.bed > other_chr1.bed
## more specific code below but the top one did work
# bedtools subtract -a genome_chr1.bed -b exons_chr1.bed | bedtools subtract -a stdin -b introns_chr1.bed | bedtools subtract -a stdin -b cCREs_chr1.bed > other_chr1.bed
