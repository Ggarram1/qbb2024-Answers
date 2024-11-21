#!/usr/bin/env python

#import necessary packages
import numpy as np # type: ignore
import matplotlib.pyplot as plt # type: ignore
import imageio.v3 as iio # type: ignore
import scipy # type: ignore
import plotly.express as px # type: ignore
import plotly # type: ignore

#list of gene names and channel names 
genes = ['APEX1', 'PIM2', 'POLR2B', 'SRSF1']
channels = ['DAPI', 'nascentRNA', 'PCNA']
fields = ['field0', 'field1']

#initializing dictionary to hold 3-channel images for each gene and field
image_data = {}

#Exercise 1: Loading the image data - Using a for loop to cycle through genes
for gene in genes:
    #initialize list to store images for current gene
    gene_images = []

    #loop through each field
    for field in fields:
        #initialize list to store images for current field
        field_channels = []

        #loop through each channel
        for channel in channels:
            #write file name for the current gene, field, and channel
            image_path = f"{gene}_{field}_{channel}.tif"

            #load image for current channel
            img = iio.imread(image_path)
            
            #normalize image
            img = img.astype(np.float32) - np.amin(img)
            img /= np.amax(img)

            #append image to list of channels for this field
            field_channels.append(img)

        #combine channels into a single 3D array (X, Y, 3) for each image
        field_image = np.stack(field_channels, axis=-1)

        #add the stacked image to list for this gene
        gene_images.append(field_image)

    #store images for this gene in dictionary
    image_data[gene] = gene_images
#This produces 8 3-colored image arrays.

#Exercise 2.1: For each image, create a binary mask from the DAPI channel
#initializing dictionary to hold the binary masks for each gene and field
binary_masks = {}

#for loop to loop through each gene and its images
for gene in genes:
    gene_masks = []

    #loop through each field
    for field_index, field in enumerate(fields):
        #get image for the current field and gene
        field_image = image_data[gene][field_index]
        
        #pull out DAPI channel
        dapi_channel = field_image[..., 0]
        
        #calculate mean value of DAPI channel
        dapi_mean = np.mean(dapi_channel)
        
        #create binary mask: true for values >= mean, false for values < mean
        mask = dapi_channel >= dapi_mean
        
        #append mask to the list for this gene
        gene_masks.append(mask)
    
    #store masks for this gene in the dictionary 
    binary_masks[gene] = gene_masks

#checking binary masks
#for gene in genes:
#    for field_index, field in enumerate(fields):
#        mask = binary_masks[gene][field_index]
#        plt.imshow(mask, cmap='gray')
#        plt.title(f"Binary Mask for {gene}, {field}")
#       plt.show()

#Exercise 2.2: Find labels for each image based on the DAPI mask from step 2.1
#using live coding "find labels" function
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

#loop over each gene and field
for gene in genes:
    for field in fields:
        #extract the DAPI mask for the current gene and field again
        dapi_mask = binary_masks[gene][fields.index(field)]

        #generate the label map using the find_labels function
        label_array = find_labels(dapi_mask)

        #create a copy of the label array to adjust the background for visualization
        label_array_copy = label_array.copy()

        #adjust the background values to make them more visible
        label_array_copy[label_array_copy == 0] -= 50 

        #display the label map
        plt.figure(figsize=(6, 6))
        plt.imshow(label_array_copy, cmap='nipy_spectral')
        plt.title(f"Label Map for {gene}, {field}")
        plt.show()

#Exercise 2.3: Filter out labeled outliers based on size
def filter_by_size(label_array, min_size=100):
    #make array 1D for bincount
    flattened = label_array.ravel()
    
    #get counts of each label
    label_counts = np.bincount(flattened)
    
    #create mask to mark labels to keep
    valid_labels = np.where(label_counts >= min_size)[0]
    
    #create new label array with "0" labels removed
    filtered_label_array = np.isin(label_array, valid_labels).astype(int) * label_array
    
    return filtered_label_array

#find sizes of each labeled object
def get_object_sizes(label_array):
    flattened = label_array.ravel()
    #ignore background
    label_counts = np.bincount(flattened)
    return label_counts[1:]

#filter based on mean size ± standard deviation
def filter_based_on_size(label_array, size_threshold=1):
    sizes = get_object_sizes(label_array)
    
    #calculate mean and standard deviation of object sizes
    mean_size = np.mean(sizes)
    std_size = np.std(sizes)
    
    #define lower and upper boundaries based on mean ± standard deviation
    lower_bound = mean_size - size_threshold * std_size
    upper_bound = mean_size + size_threshold * std_size
    
    #create a mask that marks valid labels within the size boundaries
    valid_labels = np.where((sizes >= lower_bound) & (sizes <= upper_bound))[0] + 1  # Adding 1 because bincount starts at 0
    
    #create a filtered label array with labels outside the valid range set to 0
    filtered_label_array = np.isin(label_array, valid_labels).astype(int) * label_array
    
    return filtered_label_array

#loop over genes and fields to process the label arrays
for gene in genes:
    for field in fields:
        #assuming we already have the 'binary_masks' and 'find_labels' applied previously
        #get the DAPI mask and generate the label array
        dapi_mask = binary_masks[gene][fields.index(field)]
        label_array = find_labels(dapi_mask)
        
        #filter out small objects
        filtered_labels = filter_by_size(label_array, min_size=100)
        
        #further filter based on mean size ± standard deviation
        final_filtered_labels = filter_based_on_size(filtered_labels, size_threshold=1)
        
        #create a copy of the final label array to adjust the background for visualization
        final_label_array_copy = final_filtered_labels.copy()
        
        #adjust the background values to make them more visible
        final_label_array_copy[final_label_array_copy == 0] -= 50
        
        #display the final label map
        plt.figure(figsize=(6, 6))
        plt.imshow(final_label_array_copy, cmap='nipy_spectral')
        plt.title(f"Filtered Label Map for {gene}, {field}")
        plt.show()

def calculate_log_ratio(nascentRNA_image, PCNA_image, label_array):
    #initialize an empty list to store the ratios for each nucleus
    log_ratios = []
    
    #loop through all unique labels (excluding background which is label 0)
    unique_labels = np.unique(label_array)
    
    #exclude background (label 0)
    unique_labels = unique_labels[unique_labels > 0]
    
    #for each label (nucleus), calculate the average signal for both channels and the log-transformed ratio
    for label in unique_labels:
        #create a mask for the current label
        label_mask = label_array == label
        
        #get the corresponding pixel values for nascentRNA and PCNA in the current label region
        nascentRNA_signal = nascentRNA_image[label_mask]
        PCNA_signal = PCNA_image[label_mask]
        
        #calculate the mean signal for both channels in this region
        mean_nascentRNA = np.mean(nascentRNA_signal) if len(nascentRNA_signal) > 0 else 0
        mean_PCNA = np.mean(PCNA_signal) if len(PCNA_signal) > 0 else 0
        
        #calculate the log-transformed ratio (with a small epsilon to avoid division by zero)
        if mean_PCNA > 0:  # Ensure there is a PCNA signal to divide by
            log_ratio = np.log(mean_nascentRNA / mean_PCNA)
        else:
            log_ratio = 0 
        
        #append the result (label, log_ratio) to the list
        log_ratios.append((label, log_ratio))
    
    return log_ratios

#loop through genes and fields to calculate the log ratio for each nucleus
log_ratios_data = []

for gene in genes:
    for field in fields:
        #get the images for nascentRNA and PCNA for the current gene and field
        field_image = image_data[gene][fields.index(field)]
        nascentRNA_image = field_image[..., 1]  # Assuming nascentRNA is at index 1
        PCNA_image = field_image[..., 2]  # Assuming PCNA is at index 2
        
        #get the binary mask and label array for the current gene and field
        dapi_mask = binary_masks[gene][fields.index(field)]
        label_array = find_labels(dapi_mask)
        
        #calculate the log-transformed ratios for each nucleus
        log_ratios = calculate_log_ratio(nascentRNA_image, PCNA_image, label_array)
        
        #store the log ratio data (gene, field, label, log_ratio)
        for label, log_ratio in log_ratios:
            log_ratios_data.append((gene, field, label, log_ratio))

#write the log ratio data to a text file
with open('log_ratios.txt', 'w') as f:
    # Write header
    f.write("Gene\tField\tLabel\tLog_Ratio\n")
    
    #write data for each nucleus
    for entry in log_ratios_data:
        gene, field, label, log_ratio = entry
        f.write(f"{gene}\t{field}\t{label}\t{log_ratio:.4f}\n")

print("Log ratios have been written to log_ratios.txt.")