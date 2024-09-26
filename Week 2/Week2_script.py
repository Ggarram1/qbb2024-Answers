#!/bin/bash

# Define input files
SNP_FILE="cCREs_chr1.bed"
INTRON_FILE="chr1_exons2.bed"     
EXON_FILE="chr1_exons2.bed"          
OTHER_FEATURES_FILE="other_chr1.bed" 

# Create output file for results
OUTPUT_FILE="snp_density_enrichment.txt"

# Check if input files exist
for file in "$SNP_FILE" "$INTRON_FILE" "$EXON_FILE" "$OTHER_FEATURES_FILE"; do
    if [[ ! -f $file ]]; then
        echo "Error: File $file not found!" >&2
        exit 1
    fi
done

# Define MAF thresholds
MAF_THRESHOLDS=(0.01 0.05 0.1)

# Initialize output file
echo -e "MAF\tFeature_Type\tSNP_Count\tFeature_Count\tDensity_Enrichment" > $OUTPUT_FILE

# Loop over MAF thresholds
for MAF in "${MAF_THRESHOLDS[@]}"; do
    echo "Filtering SNPs for MAF=${MAF}..."
    FILTERED_SNPS="filtered_snps_${MAF}.bed"
    awk -v maf="$MAF" '$NF >= maf' $SNP_FILE > $FILTERED_SNPS

    # Check if any SNPs were filtered
    if [[ ! -s $FILTERED_SNPS ]]; then
        echo "Warning: No SNPs found for MAF=${MAF}. Skipping this MAF threshold."
        continue
    fi

    # Count total SNPs
    TOTAL_SNPS=$(wc -l < $FILTERED_SNPS)

    # Define an array of feature files
    FEATURE_FILES=( "$INTRON_FILE" "$EXON_FILE" "$OTHER_FEATURES_FILE" )
    FEATURE_NAMES=("Intron" "Exon" "Other")

    # Loop through each feature type
    for i in "${!FEATURE_FILES[@]}"; do
        FEATURE_FILE="${FEATURE_FILES[i]}"
        FEATURE_NAME="${FEATURE_NAMES[i]}"
        
        echo "Intersecting features with filtered SNPs for ${FEATURE_NAME}..."
        OVERLAP_FILE="overlap_${FEATURE_NAME}_${MAF}.bed"
        bedtools intersect -a $FEATURE_FILE -b $FILTERED_SNPS > $OVERLAP_FILE

        # Count features and SNPs in the overlap
        FEATURE_COUNT=$(wc -l < $FEATURE_FILE)
        SNP_COUNT=$(wc -l < $OVERLAP_FILE)

        # Calculate SNP density enrichment
        if [[ $FEATURE_COUNT -gt 0 ]]; then
            DENSITY_ENRICHMENT=$(echo "scale=4; $SNP_COUNT / $FEATURE_COUNT" | bc)
        else
            DENSITY_ENRICHMENT=0
        fi

        # Write results to output file
        echo -e "${MAF}\t${FEATURE_NAME}\t${SNP_COUNT}\t${FEATURE_COUNT}\t${DENSITY_ENRICHMENT}" >> $OUTPUT_FILE
    done

    # Clean up intermediate overlap files
    rm overlap_*.bed
done

# Clean up filtered SNPs
rm filtered_snps_*.bed

echo "SNP density enrichment calculation complete. Results saved to $OUTPUT_FILE."