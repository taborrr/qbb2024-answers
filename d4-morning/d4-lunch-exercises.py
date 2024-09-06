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
    # create key from gene and tissue
    key = (fields[0], fields[2])
    # initialize dict from key with list to hold samples
    relv_samp[key] = []
fs.close()

####################################
# get metadata file name Annotations
metadata = sys.argv[2]

# open file
fs = open(metadata, mode='r')
# skip line
fs.readline()

# create dict to hold samples for tissue name
tis_samples = {}

# iterate each line in ?
for line in fs:
    # split line into fields
    fields = line.rstrip("\n").split("\t")
    # create key from gene and tissue
    key = fields[6]
    value = fields[0]
    # initialize dict from key with list to hold samples
    tis_samples.setdefault(key, [])
    tis_samples[key].append(value)
fs.close()


####################################
# get expression file name (test) (or 2017)
xpr_data = sys.argv[3]

# open file
fs = open(xpr_data, mode='r')
# skip line
fs.readline()
fs.readline()
header = fs.readline().rstrip("\n").split("\t")
header = header[2:]

tissue_col = {}
for tissue, samples in tis_samples.items():
    tissue_col.setdefault(tissue, [])
    for sample in samples:
        if sample in header:
            position = header.index(sample)
            tissue_col[tissue].append(position)
print(tissue_col)

fs.close()