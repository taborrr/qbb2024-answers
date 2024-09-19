README file for week 1
Tabor Roderiques


# exercise 1: coverage simulator
# step 1.1
## how many 100bp reads are needed to sequence a 1Mbp genome to 3x coverage?
Coverage desired * genome size / read length = number of reads 
3 * 1,000,000 / 100 = 30000
30,000 reads of length 100bp are necessary to achieve 3x coverage of a 1Mbp genome in a perfect world

# step 1.4
## 1.4.1
## how much of genome not sequenced
From the graph it looks like above 50,000 positions in the genome were not sequenced and represented in a read of 100bp. The actual 0x coverage = 5.1805% 
5.1805% of the genome has not been sequenced, no reads had mapped to that percent of the genome. 51,805 positions out of the 1Mbp genome had no reads covering them. 
## 1.4.2
## How well does this match Poisson expectations? How well does the normal distribution fit the data?
# poisson estimate = 4.9787% not sequenced
# normal estimate = 5.1393% not sequenced
Poisson expectations of 0 coverage positions were at 0.2% less of the genome compared to the actual coverage: 5.3991% - 4.9787% = 0.4%. Note that the actual coverage used numpy random read generation. 
When looking at the actual number of positions in the genome with 0 coverage depth, the Poisson is very close to the actual percentage. That is, out of 1000000 positions, the Poisson estimated around 4000 less positions would not be sequenced than the actual. 
The normal distribution is more noticeably unaligned across the observed depth coverage values (0-13) than the Poisson but still relatively close, with the majority of the offsetting taking the form of a slightly right shifted curve for all the estimates.

# step 1.5
# step 1.5.3.1
0.012% of the genome has not been sequenced when there has been 10x coverage of reads. This comes out to 117 positions out of 1000000 not having been sequenced. This is dramatically improved from the unsequenced positions from 3x coverage. 
# step 1.5.3.2
The Poisson estimated 0.0045% 0x coverage of the genome which is 45 positions not sequenced, this value is only different by 0.008% of the genome or 80 positions. This is way closer that during the 3x coverage comparison of the Poisson to the actual. 
Based on the functions graphed over the histogram, the Normal distribution demonstrates a more precise congruity with the actual coverage than during the 3x estimation graph, only having a discernable difference at the peak which is at the 9x position. 
The normal distribution is fitting the data better as there is higher coverage of the genome.

# step 1.6
# step 1.6.3.1
In my simulation, 0.0008% of the genome has not been sequenced. This equates to 8 positions out of 1000000 that have 0x coverage. This is very improved from 10x and outstandingly improved from 3x genome coverage.
# step 1.6.3.2
Poisson expectations were that 0.000000000009% of the genome would not be sequenced which is approximately 0.00000009 points with 0x coverage. This is a 100,000,000th of a point to remain unsequenced and that means very clearly that the Poisson expectations were to have every position sequenced.
The normal distribution is even better than 10x. The normal's curve is slightly right shfited still compared to the actual histogram but by a much smaller margin than in the previous coverages. This demonstrates that the greater the genome coverage (3x, 10x, 30x) the more congruent the normal, poisson, and the actual data align. 



# step 2.6

TCTTATTGATTCATTT