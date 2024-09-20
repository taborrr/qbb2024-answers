#!/usr/bin/env python3

import numpy
import scipy
import os


# exercise 1
# step 1.1
cov = 3
genome_size = 1000000
read_len = 100
num_read = (cov * genome_size / read_len)
# print(num_read)
# 30,000 reads of length 100bp are necessary to achieve 3x coverage of a 3Mbp genome

# step 1.2
# define the file name as a variable
file_name = "genome_coverage3x.txt"

# step 1.5
cov = 10
num_read = (cov * genome_size / read_len)
# print(num_read)
file_name = "genome_coverage10x.txt"

# step 1.6
cov = 30
num_read = (cov * genome_size / read_len)
print(num_read)
file_name = "genome_coverage30x.txt"

### code
### code to create txt file of 1 column of coverage across genome
### code
# calculate number of reads
num_read = (cov * genome_size / read_len)
# create reads and empty array
reads = numpy.random.randint(0,999900, size = int(num_read))
genome_coverage = numpy.zeros(1000000, dtype = int)
# for all reads, add 1 to the zeros array at evry position that a particular read spans
for i in reads:
    start = i
    end = (start + read_len - 1)  # -1 because position must be accounted for after addition
    genome_coverage[start:end] += 1
# check if the file already exists in the current directory
if os.path.exists(file_name):
    print(f"File '{file_name}' already exists. Skipping file creation.")
else:
    # write array to a txt file if it does not exist
    with open(file_name, "w") as file:
        for value in genome_coverage:
            file.write(str(value) + "\n")
    print(f"File '{file_name}' created.")