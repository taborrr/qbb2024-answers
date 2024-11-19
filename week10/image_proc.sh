#!/usr/bin/env python

import imageio
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import plotly.express as px
import plotly

na = np.newaxis

# List of all .tif files
tif_files = [
    "APEX1_field0_DAPI.tif", "APEX1_field0_PCNA.tif", "APEX1_field0_nascentRNA.tif",
    "APEX1_field1_DAPI.tif", "APEX1_field1_PCNA.tif", "APEX1_field1_nascentRNA.tif",
    "PIM2_field0_DAPI.tif", "PIM2_field0_PCNA.tif", "PIM2_field0_nascentRNA.tif",
    "PIM2_field1_DAPI.tif", "PIM2_field1_PCNA.tif", "PIM2_field1_nascentRNA.tif",
    "POLR2B_field0_DAPI.tif", "POLR2B_field0_PCNA.tif", "POLR2B_field0_nascentRNA.tif",
    "POLR2B_field1_DAPI.tif", "POLR2B_field1_PCNA.tif", "POLR2B_field1_nascentRNA.tif",
    "SRSF1_field0_DAPI.tif", "SRSF1_field0_PCNA.tif", "SRSF1_field0_nascentRNA.tif",
    "SRSF1_field1_DAPI.tif", "SRSF1_field1_PCNA.tif", "SRSF1_field1_nascentRNA.tif"
    ]
genes = ["APEX1", "PIM2", "POLR2B", "SRSF1"] 
fields = [0, 1]
channels = ["DAPI", "PCNA", "nascentRNA"]

# Create the 8 (X, Y, 3) arrays
image_arrays = []
for gene in genes:
    for field in fields:
        rgb_img = None
        for i, channel in enumerate(channels):
            filename = f"{gene}_field{field}_{channel}.tif"
            img = imageio.v3.imread(filename).astype(np.uint16)
            if rgb_img is None:
                rgb_img = np.zeros((img.shape[0], img.shape[1], 3), dtype=np.uint16)
            rgb_img[:, :, i] = img
        image_arrays.append(rgb_img)


binary_masks = []
for image in image_arrays:
    dapi_channel = image[:, :, 0].astype(np.float32)
    mean_value = np.mean(dapi_channel)
    mask = dapi_channel >= mean_value
    binary_masks.append(mask)

plt.imshow(binary_masks[0])
plt.show()

# Let's use a function to find nuclei bodies
def find_labels(mask):
    l = 0
    labels = np.zeros(mask.shape, np.int32)
    equivalence = [0]
    if mask[0, 0]:
        l += 1
        equivalence.append(l)
        labels[0, 0] = l
    for y in range(1, mask.shape[1]):
        if mask[0, y]:
            if mask[0, y - 1]:
                labels[0, y] = equivalence[labels[0, y - 1]]
            else:
                l += 1
                equivalence.append(l)
                labels[0, y] = l
    for x in range(1, mask.shape[0]):
        if mask[x, 0]:
            if mask[x - 1, 0]:
                labels[x, 0] = equivalence[labels[x - 1, 0]]
            elif mask[x - 1, 1]:
                labels[x, 0] = equivalence[labels[x - 1, 1]]
            else:
                l += 1
                equivalence.append(l)
                labels[x, 0] = l
        for y in range(1, mask.shape[1] - 1):
            if mask[x, y]:
                if mask[x - 1, y]:
                    labels[x, y] = equivalence[labels[x - 1, y]]
                elif mask[x - 1, y + 1]:
                    if mask[x - 1, y - 1]:
                        labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x - 1, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    elif mask[x, y - 1]:
                        labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    else:
                        labels[x, y] = equivalence[labels[x - 1, y + 1]]
                elif mask[x - 1, y - 1]:
                    labels[x, y] = equivalence[labels[x - 1, y - 1]]
                elif mask[x, y - 1]:
                    labels[x, y] = equivalence[labels[x, y - 1]]
                else:
                    l += 1
                    equivalence.append(l)
                    labels[x, y] = l
        if mask[x, -1]:
            if mask[x - 1, -1]:
                labels[x, -1] = equivalence[labels[x - 1, -1]]
            elif mask[x - 1, -2]:
                labels[x, -1] = equivalence[labels[x - 1, -2]]
            elif mask[x, -2]:
                labels[x, -1] = equivalence[labels[x, -2]]
            else:
                l += 1
                equivalence.append(l)
                labels[x, -1] = l
    equivalence = np.array(equivalence)
    for i in range(1, len(equivalence))[::-1]:
        labels[np.where(labels == i)] = equivalence[i]
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        labels[np.where(labels == j)] = i
    return labels

lab_array = []
for mask in binary_masks:
    labels = find_labels(mask)
    lab_array.append(labels)
print(type(lab_array))
lab_array = np.array(lab_array)
print(type(lab_array)) # now numpy.ndarray
plt.imshow(lab_array[0])
plt.show()

# Since the first label is 1 and the background is 0, let's adjust the background for more contrast
label_copy = np.copy(labels)
label_copy[np.where(label_copy == 0)] -= 50
plt.imshow(label_copy)
plt.show()

# Filter cells
for labels in lab_array:
    sizes = np.bincount(labels.ravel())
    for i in range(1, np.amax(labels)+1):
        where = np.where(labels == i)
        if sizes[i] < 100:
            labels[where] = 0

def filter_by_size(labels):
    sizes = np.bincount(labels.ravel())
    non_zero_sizes = sizes[1:]  # Skip the background (label 0)
    mean_size = np.mean(non_zero_sizes)
    std_size = np.std(non_zero_sizes)
    minsize = mean_size - std_size
    maxsize = mean_size + std_size
    for i in range(1, sizes.shape[0]):
        if sizes[i] < minsize or sizes[i] > maxsize:
            where = np.where(labels == i)
            labels[where] = 0
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        labels[np.where(labels == j)] = i
    return labels

for t in range(len(lab_array)):
    lab_array[t] = filter_by_size(lab_array[t])

plt.imshow(lab_array[0])
plt.show()

# exercise 3
# mostly manually influenced iteration strategy
gene_map = np.array(["APEX1", "APEX1", "PIM2", "PIM2", "POLR2B", "POLR2B", "SRSF1", "SRSF1"])
field_map = np.array([0, 1, 0, 1, 0, 1, 0, 1])
data = []
for img in range(len(lab_array)):
    nuclei_indices = np.unique(lab_array[img])
    nuclei_indices = nuclei_indices[nuclei_indices > 0]  # Skip background (nuc = 0)
    for nuc in nuclei_indices:
        where = np.where(lab_array[img] == nuc)
        pcna_signal = np.mean(image_arrays[img][where][1])
        nrna_signal = np.mean(image_arrays[img][where][2])
        nuc_log2_raysh = np.log2(nrna_signal / pcna_signal)
        data.append({
            "gene": gene_map[img],
            "field": field_map[img],
            "nucleiNumber": nuc,
            "nascentRNA": nrna_signal,
            "PCNA": pcna_signal,
            "log2_nRNA_PCNA": nuc_log2_raysh
        })

# Save to CSV
pd.DataFrame(data).to_csv("RNAprod_nucSegmentaysh.csv", sep=",", header=True, index=False, mode="w")

print("ad victoriam...")


