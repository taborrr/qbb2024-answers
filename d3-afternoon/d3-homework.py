#!/usr/bin/env python3

import sys
import numpy
# open file
fs = open(sys.argv[1], mode="r")

# skip 2 lines
fs.readline()
fs.readline()

# split column by tabs and skip first two entries
line = fs.readline()
fields = line.strip("\n").split("\t")
tissues = fields[2:]

# create way to hold gene names
# create way to hold gene IDs
# create way to hold expression values
gene_IDs = []
gene_names = []
expression = []

# for each line
#     split the line
#     save field 0 into gene IDs
#     save field 1 into gene names
#     save 2+ into expression values
for line in fs:
    fields = line.strip("\n").split("\t")
    gene_IDs.append(fields[0])
    gene_names.append(fields[1])
    expression.append(fields[2:])

# close file
fs.close()

# convert to numpy arrays
tissues = numpy.array(tissues)
gene_IDs = numpy.array(gene_IDs)
gene_names = numpy.array(gene_names)
expression = numpy.array(expression, dtype=float)

print("\n")
print("Question 3")
## Answer 3
for i in range(10):
    mean_temp = 0
    g_tot = 0
    for g in range(len(expression[i])):
        g_tot += expression[i][g]
    mean_temp = (g_tot / len(expression[i]))
    print(gene_names[i], "mean gene expression", mean_temp)

print("\n")
print("Question 4")
## Answer 4
gene_xpresh_mean = numpy.mean(expression, axis=1)[:10]
print(gene_xpresh_mean)

print("\n")
print("Question 5")
## Answer 5
mean_x = numpy.mean(expression)
median_x = numpy.median(expression)
print(mean_x)
print(median_x)

print("\n")
print("Question 6")
## Answer 6
expression += 1
log2_xpr = numpy.log2(expression)
mean_x = numpy.mean(log2_xpr)
median_x = numpy.median(log2_xpr)
print(mean_x)
print(median_x)

### Before transformation the mean and median were 16.56 and 0.03 respectively 
### and now they are 1.12 and 0.04 respectively which is significantly closer
### together because of the log2 normalization. The log2 transformation affected
### the mean more than the median.

print("\n")
print("Question 7")
## Answer 7
## find dif between highest two expressions of a gene and identify that tissue
xp_diff = numpy.copy(log2_xpr)
sort_log2_xpr = numpy.sort(log2_xpr, axis=1)
diff_array = sort_log2_xpr[:,-1] - sort_log2_xpr[:,-2]
print(diff_array)


print("\n")
print("Question 8")
## Answer 8
## dif of 1000x or more
#print(diff_array[numpy.where(diff_array >= 10)])
print(numpy.sum(diff_array >= 10), "count of significantly differentially expressed genes")
## there are 33 genes identified whose difference between the highest and second highest tissue expression is greater than 10

# print("\n")
# print("Advanced Question 9")
# ## Advanced Answer 9
# zero_mimic = numpy.zeros(log2_xpr)
# numpy.argmax(log2_xpr)
