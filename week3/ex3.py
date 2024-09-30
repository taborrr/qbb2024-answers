#!/usr/bin/env python3

# in command line, run touch AF.txt
import sys
vcf_2a = sys.argv[1] #biallelic.vcf
af_file = sys.argv[2] #AF.txt

### Question 3.1 ###
# Open empty txt in write mode
with open(af_file, 'w') as af:
    # Iterate each line of VCF file
    for l in open(vcf_2a):
        # Skip header lines that start with '#'
        if l.startswith('#'):
            continue
        
        # Split line into fields, and fields into info terms
        fields = l.rstrip('\n').split('\t')
        info_f = fields[7]
        infos = info_f.split(';')
        
        # Look for 'AF' in INFO
        af_value = None
        for i in infos:
            if i.startswith('AF='):
                af_value = i.split('=')[1]
                break  # Stop once AF is found
        
        # If AF was found, write it to the file
        if af_value is not None:
            af.write(af_value + '\n')



### Question 3.2 ###
#


### Question 3.3 ###
#


### Question 3.4 ###
#


### Question 3.5 ###
#


### Question 3.6 ###
#

