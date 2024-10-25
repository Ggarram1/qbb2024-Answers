## Question Responses ##
1.1: Do any metrics stand out as problematic? Can you think of a reason why this sample does not match the expected GC content distribution and base content at the beginning of sequences? 
    Both the per base sequence content and the GC content distribution stand out as not as predicted. The per-base sequence content seems to stabilize as the position within the read moves forward. This is fairly logical and suggests that the reliability/stability of the reads increases with the later positions. For the GC content however, there is a clear spike in GC content, above even the predicted increase. This may be due to a variety of factors - from GC content generally increasing stability, or even leading to formation of secondary structures, to more problematic reasons like ds breaks leading to increased GC content. As the observed GC peak is still within the region of the predicted GC peak, it is more likely that this can be attributed to the former reasoning.

1.2: What is the origin of the most overrepresented sequence in this sample? Does it make sense?
    The most overrepresented sequence (CTTGACCAAGATGAAACTGTTCGTATTCCTGGCCTTGGCCGTGGCCGCAA) blasts (with 100% identity) to Drosophila melanogaster strain Canton S serine protease 3, serine protease 1 (SER1), and serine protease 2 (SER2) genes. Given the source of the data, Drosophila midgut, and that these are cell renewal (a process that occurs frequently in the gut) proteases, this is a very logical finding.

2: If you were to reject any samples with the percentage of unique reads less than 45%, how many samples would you keep? Can you see the blocks of triplicates clearly? Try adjusting the min slider up. Does this suggest anything about consistency between replicates?
    All of the samples have greater that at least 45% unique reads - in fact, they all have greater than 55% unique reads. For this reason, all samples may be kept. 
    When the sliders are unadjusted, it is a bit challenging to distinguish between the triplicates. However, adjusting the sliders (both min and max) makes this distinction more clear. This suggests a high consistency in across the replicates, and really just within the data overall (although a different type of consistency).

3.3 What does the PCA plot suggest to you about the data? Why?
    The PCA plot suggests the variance across the data can be explained by the location from which the samples were taken, with the first and third triplicate regions being more similar to each other than either is to the second.

3.6 Do the categories of enrichments make sense? Why?
    The categories of enrichments mostly make sense! They are primarily for genes associated with digestion and metabolism. As these are gut tissue samples, this is quite logical. I was a bit surprised that the bicarbonate transport was the most enriched, but this is the only category that was unexpected.
