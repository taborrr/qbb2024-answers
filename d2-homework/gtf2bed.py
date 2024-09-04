#!/usr/bin/env python3

import sys

file = open( sys.argv[1] )

for line in file:
    line = line.rstrip("\n")
    if "##" in line:
        continue
    fields = line.split("\t")
  
    text = fields[8]
    
    start_delimiter = 'gene_id "'
    end_delimiter = '"'

    # Find the start index of the gene_id value
    start_index = text.find(start_delimiter) + len(start_delimiter)

    # Find the end index of the gene_id value
    end_index = text.find(end_delimiter, start_index)

    # Extract the substring between the delimiters
    extracted_value = text[start_index:end_index]

    print(str(fields[0]) + '\t' + str(fields[3]) + '\t' + str(fields[4]) + '\t' + extracted_value)

file.close()
