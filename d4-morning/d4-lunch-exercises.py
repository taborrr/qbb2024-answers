#!/usr/bin/env python3


# day 4 lunch exercises

import sys
import numpy

####################################
# get file name (gene_tissue)
filename = sys.argv[1]

# open file
fs = open(filename, mode='r')

# create dict to hold samples for gene-tissue pairs
relv_samp = {}

# iterate each line in gene_tissue file
for line in fs:
    # split line into fields
    fields = line.rstrip("\n").split("\t")
    # create key from gene IDs
    key = (fields[0]) 
    # initialize dict from key with tissue values
    relv_samp[key] = fields[2]
fs.close()


####################################
# get metadata file name Annotations
metadata = sys.argv[2]

# open file and skip line
fs = open(metadata, mode='r')
fs.readline()

# create dict to hold samples for tissue name
tis_samples = {}

# iterate each line in annotations
for line in fs:
    # split line into fields
    fields = line.rstrip("\n").split("\t")
    # create key from sample ID and tissue (SMTSD)
    key = fields[6]
    value = fields[0]
    # initialize dict from key with list to hold samples
    tis_samples.setdefault(key, [])
    tis_samples[key].append(value)
fs.close()

####################################
# get expression file name 
xpr_data = sys.argv[3]

# open file and skip lines
fs = open(xpr_data, mode='r')
fs.readline()
fs.readline()
# list of sampleIDs present in the expression file
header = fs.readline().rstrip("\n").split("\t")
header = header[2:]

# exercise 5
tissue_col = {}
for tissue, samples in tis_samples.items():
    tissue_col.setdefault(tissue, [])
    for sample in samples:
        if sample in header:
            position = header.index(sample)
            tissue_col[tissue].append(position)
fs.close()

## what tissue types have the largest number of samples?
# longest_keys = []
# longest_length = 0
# for key, value in tissue_col.items():
#     current_length = len(value)
#     if current_length > longest_length:
#         longest_keys = [key] 
#         longest_length = current_length
#     elif current_length == longest_length:
#         longest_keys.append(key) 
# print(longest_keys, longest_length)
## Muscle - Skeletal has the most with 803 samples

## the fewest number of samples?
# shortest_keys = []
# shortest_length = float('inf')  # infinity
# for key, value in tissue_col.items():
#     current_length = len(value)
#     if current_length < shortest_length:
#         shortest_keys = [key]
#         shortest_length = current_length
#     elif current_length == shortest_length:
#         shortest_keys.append(key)
# print(shortest_keys, shortest_length)
# Cells - Leukemia cell line (CML) has the fewest with 0 samples

# exercise 6

# open expression file and skip lines
fs = open(xpr_data, mode='r')
fs.readline()
fs.readline()
fs.readline()

# list of list soon to be containing gene, tissue, expression data
gtx_a = []
# iterate through each line of expression data
for line in fs:
    # split up the expression data and store numbers in array
    gene_row = fs.readline().rstrip("\n").split("\t")
    gene_row_xpr_val = numpy.array(gene_row[2:])
    # name gene ID variable and check if exists in relevant samples dict
    temp_gene_id = str(gene_row[0])
    exists = temp_gene_id in relv_samp
    # if gene exists in dict 
    if exists == True:
        temp_tis = relv_samp.get(temp_gene_id)
        g_t_x_data = gene_row_xpr_val[tissue_col[temp_tis]]
        gtx_a.append([temp_gene_id, temp_tis, g_t_x_data])
fs.close()

# exercise 7
## make tab sep file 3 columns: xpression value \t geneID \t tissue\n
# for a in gtx_a:
#     for b in a[2]:
#         print(b, a[0], a[1])

import csv

# specify path
file_path = 'results_exercise7_full.tsv'

# open file in write mode
with open(file_path, 'w', newline='') as file:
    # create CSV writer object
    writer = csv.writer(file, delimiter='\t')
    # iterate through data
    for a in gtx_a:
        for b in a[2]:
            # write each row to the file
            writer.writerow([b, a[0], a[1]])