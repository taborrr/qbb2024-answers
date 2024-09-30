#!/usr/bin/env python3

# in command line, run touch AF.txt, and touch DP.txt
import sys

vcf_2a = sys.argv[1] #biallelic.vcf
af_file = sys.argv[2] #AF.txt
dp_file = sys.argv[3] # DP.txt

### Question 3.1 ###
with open(af_file, 'w') as af:
    # Iterate each line of VCF file
    for l in open(vcf_2a):
        # Skip header lines that start with '#'
        if l.startswith('#'):
            continue
        # Split line into fields, and fields into info terms
        fields = l.rstrip('\n').split('\t')

        code for AF
        info_f = fields[7]
        infos = info_f.split(';')
        # Look for AF in INFO
        af_value = None
        for i in infos:
            if i.startswith('AF='):
                af_value = i.split('=')[1]
                break  # Stop once AF is found
        # If AF was found, write it to the file
        if af_value is not None:
            af.write(af_value + '\n')

        # code for DP
        form = fields[]


### Question 3.2 ###
with open(dp_file, 'w') as dp:
    # header
    dp.write("DP\n")
    # iterate each line of VCF
    for l in open(vcf_2a):
        # skip headers that start with '#'
        if l.startswith('#'):
            continue
        # split line into fields
        fields = l.rstrip('\n').split('\t')
        # iterate through each sample 
        for sample_info in fields[9:]:
            # split sample info into a list
            sample_datas = sample_info.split(':')
            # get DP in sample data which is 3rd
            dp_value = None
            dp_value = sample_datas[2]
            # if a DP value is found, write it to the output file
            if dp_value is not None:
                dp.write(dp_value + '\n')
