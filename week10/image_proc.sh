#!/usr/bin/env python

import numpy as np
import scipy
import matplotlib.pyplot as plt
import imageio
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
# Iterate through genes and fields
for gene in genes:
    for field in fields:
        # Initialize an array for combining 3 channels
        rgb_img = None
        # Read all channels for the current gene and field
        for i, channel in enumerate(channels):
            # Construct filename
            filename = f"{gene}_field{field}_{channel}.tif"
            if filename not in tif_files:
                raise ValueError(f"File {filename} not found!")
            # Load the channel
            img = imageio.v3.imread(filename).astype(np.uint16)
            # Initialize rgb_img
            if rgb_img is None:
                rgb_img = np.zeros((img.shape[0], img.shape[1], 3), dtype=np.uint16)
            # Add the channel
            rgb_img[:, :, i] = img
        # Append the combined image to the list
        image_arrays.append(rgb_img)
# Now `image_arrays` contains 8 arrays of shape (X, Y, 3), one for each gene/field
print(f"Processed {len(image_arrays)} images with shape {image_arrays[0].shape}")

# Display image
plt.imshow(image_arrays[0])

# Create a list to store the binary masks
binary_masks = []
# Iterate over the image arrays to create binary masks from the DAPI channel
for image in image_arrays:
    # Extract the DAPI channel (first channel)
    dapi_channel = image[:, :, 0].astype(np.float32)
    # Calculate the mean value of the DAPI channel
    mean_value = np.mean(dapi_channel)
    # Create the binary mask using the mean as the cutoff
    mask = dapi_channel >= mean_value
    # Append the mask to the list
    binary_masks.append(mask)

plt.imshow(binary_masks[0])
plt.show()

# Let's use a function to find nuclei bodies
def find_labels(mask):
    # Set initial label
    l = 0
    # Create array to hold labels
    labels = np.zeros(mask.shape, np.int32)
    # Create list to keep track of label associations
    equivalence = [0]
    # Check upper-left corner
    if mask[0, 0]:
        l += 1
        equivalence.append(l)
        labels[0, 0] = l
    # For each non-zero column in row 0, check back pixel label
    for y in range(1, mask.shape[1]):
        if mask[0, y]:
            if mask[0, y - 1]:
                # If back pixel has a label, use same label
                labels[0, y] = equivalence[labels[0, y - 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[0, y] = l
    # For each non-zero row
    for x in range(1, mask.shape[0]):
        # Check left-most column, up  and up-right pixels
        if mask[x, 0]:
            if mask[x - 1, 0]:
                # If up pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 0]]
            elif mask[x - 1, 1]:
                # If up-right pixel has label, use that label
                labels[x, 0] = equivalence[labels[x - 1, 1]]
            else:
                # Add new label
                l += 1
                equivalence.append(l)
                labels[x, 0] = l
        # For each non-zero column except last in nonzero rows, check up, up-right, up-right, up-left, left pixels
        for y in range(1, mask.shape[1] - 1):
            if mask[x, y]:
                if mask[x - 1, y]:
                    # If up pixel has label, use that label
                    labels[x, y] = equivalence[labels[x - 1, y]]
                elif mask[x - 1, y + 1]:
                    # If not up but up-right pixel has label, need to update equivalence table
                    if mask[x - 1, y - 1]:
                        # If up-left pixel has label, relabel up-right equivalence, up-left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x - 1, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x - 1, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    elif mask[x, y - 1]:
                        # If left pixel has label, relabel up-right equivalence, left equivalence, and self with smallest label
                        labels[x, y] = min(equivalence[labels[x, y - 1]], equivalence[labels[x - 1, y + 1]])
                        equivalence[labels[x, y - 1]] = labels[x, y]
                        equivalence[labels[x - 1, y + 1]] = labels[x, y]
                    else:
                        # If neither up-left or left pixels are labeled, use up-right equivalence label
                        labels[x, y] = equivalence[labels[x - 1, y + 1]]
                elif mask[x - 1, y - 1]:
                    # If not up, or up-right pixels have labels but up-left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x - 1, y - 1]]
                elif mask[x, y - 1]:
                    # If not up, up-right, or up-left pixels have labels but left does, use that equivalence label
                    labels[x, y] = equivalence[labels[x, y - 1]]
                else:
                    # Otherwise, add new label
                    l += 1
                    equivalence.append(l)
                    labels[x, y] = l
        # Check last pixel in row
        if mask[x, -1]:
            if mask[x - 1, -1]:
                # if up pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -1]]
            elif mask[x - 1, -2]:
                # if not up but up-left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x - 1, -2]]
            elif mask[x, -2]:
                # if not up or up-left but left pixel is labeled use that equivalence label 
                labels[x, -1] = equivalence[labels[x, -2]]
            else:
                # Otherwise, add new label
                l += 1
                equivalence.append(l)
                labels[x, -1] = l
    equivalence = np.array(equivalence)
    # Go backwards through all labels
    for i in range(1, len(equivalence))[::-1]:
        # Convert labels to the lowest value in the set associated with a single object
        labels[np.where(labels == i)] = equivalence[i]
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

labels = find_labels(mask)
# Since the first label is 1 and the background is 0, let's adjust the background for more contrast
label_copy = np.copy(labels)
label_copy[np.where(label_copy == 0)] -= 50
plt.imshow(label_copy)
plt.show()

# # Filter cells
sizes = np.bincount(labels.ravel())
print(sizes)
for i in range(sizes.shape[0]):
    if sizes[i] < 100:
        labels[np.where(labels == i)] = 0

def filter_by_size(labels, minsize, maxsize):
    # Find label sizes
    sizes = np.bincount(labels.ravel())
    # Iterate through labels, skipping background
    for i in range(1, sizes.shape[0]):
        # If the number of pixels falls outsize the cutoff range, relabel as background
        if sizes[i] < minsize or sizes[i] > maxsize:
            # Find all pixels for label
            where = np.where(labels == i)
            labels[where] = 0
    # Get set of unique labels
    ulabels = np.unique(labels)
    for i, j in enumerate(ulabels):
        # Relabel so labels span 1 to # of labels
        labels[np.where(labels == j)] = i
    return labels

# Let's look at the labels after filtering
label_copy = np.copy(labels)
label_copy[np.where(label_copy == 0)] -= 50
plt.imshow(label_copy)
plt.show()

# What if we want to select a single marked nucleus?
marked = np.copy(mask).astype(np.int32)
where = np.where(labels == 50)
marked[where] = 2

# And if we want information about that nucleus in another channel?
minv = np.amin(img1[where])
maxv = np.amax(img1[where])
print(f"RNA nuclear signal ranges from {minv} to {maxv}")

# Now let's see what a kernel is and what it does
kernel = np.zeros((9, 9), np.float32)
# Add two normal curves, one across rows, one across columns
kernel += scipy.stats.norm.pdf(np.linspace(-2, 2, 9))[:, na]
kernel *= scipy.stats.norm.pdf(np.linspace(-2, 2, 9))[na, :]

plt.imshow(kernel)
plt.show()

# Let's see what happens when we apply the kernel
blurred = scipy.ndimage.convolve(img2, kernel)
blurred -= np.amin(blurred)
scores = np.copy(blurred.ravel())
scores.sort()
blurred = np.minimum(1, blurred / scores[int(0.99*scores.shape[0])])

# Let's also change the dynamic range on img2
img2 -= np.amin(img2)
scores = np.copy(img2.ravel())
scores.sort()
img2 = np.minimum(1, img2 / scores[int(0.99*scores.shape[0])])

# We need to combine the images
combined = np.concatenate((img2[:, :, na], blurred[:, :, na]), axis=2)

# Now we can view them with plotly
fig = px.imshow(combined, facet_col=2)
fig.show()

# Let's look at another kernel
kernel = np.array([[1, 0, -1], [2, 0, -2], [1, 0, -1]])
plt.imshow(kernel, vmin=-2, vmax=2)
plt.show()

# Apply kernel in vertical and horizontal directions
filtered_x = scipy.ndimage.convolve(img, kernel)
filtered_y = scipy.ndimage.convolve(img, kernel.T)
filtered = (filtered_x**2 + filtered_y**2) ** 0.5

# Now let's combine the images so we do a fancy display
fullfig = np.concatenate((img[:,:,na], filtered_x[:,:,na], filtered_y[:,:,na], filtered[:,:,na]), axis=2)

# And rescale each layer independently
fullfig -= np.amin(fullfig.reshape(-1, 4), axis=0)
fullfig /= np.amax(fullfig.reshape(-1, 4), axis=0)

# And finally plot them in a linked and interactive plot
fig = px.imshow(fullfig, facet_col=2)
fig.show()