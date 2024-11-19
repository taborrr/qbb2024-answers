# Image Processing
## Week 10, November 2024
## Tabor "Attila" Roderiques
### Exercise 3

#### Step 3.1
• *What do each of these values mean, based on the descriptions of what is being labeled?*

The nuclear nascent RNA signal reflects current RNA production rates for each cell, while the nuclear PCNA signal signifies cell-cycle activity and DNA replication status. The log2 ratio of nRNA/PCNA compares transcription relative to replication activity, which allows us to quantitatively see how RNA production scales with the cell cycle.

#### Step 3.2
• *Look at the knocked-down gene with the highest ratio and the one with the lowest ratio. Look up what their functions are and explain if you think this result makes sense.*

The gene knockout condition that resulted in the highest or lowest ratio of transcriptional activity to DNA replication activity were SRSF1 and APEX1 respectively. Knocking out SRSF1 resulted in more RNA production, the highest ratio of RNA production to DNA replication. This encodes an RNA splicing and stability regulator, such that when it is knocked out there is more introns present and more of the nascent RNA transcript available at that moment in time for imaging. Loss of APEX1 resulted in less DNA replication, and had the lowest ratio. This makes sense because APEX1 is a DNA repair enzyme, such that after it is knocked out the cell scrambles to overproduce DNA replication machinery as it attempts to rescue itself which results in more PCNA and explains the lowest ratio. 