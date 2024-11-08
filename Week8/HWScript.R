#Load necessary packages for single cell data, 10x Genomics data, QC and visualization, 
#and single cell data analysis
BiocManager::install("zellkonverter")
library("zellkonverter")
library("scater")        
library("scran")       
library("ggplot2") 

setwd("~/qbb2024-Answers/Week8/")
#Load data
readH5AD("v2_fca_biohub_gut_10x_raw.h5ad")


#create single cell experiment
gut <- readH5AD ("v2_fca_biohub_gut_10x_raw.h5ad")
gut

#change assay name from X to counts
assayNames(gut) <- "counts"

#normalize counts
gut <- logNormCounts(gut)

#Q.1.1:How many genes are quantitated (should be >10,000)?
  #there are 13,407 genes quantitated.
#Q.1.2:How many cells are in the dataset?
  #there are 11,788 cells in the data set.
#Q.1.3:What dimension reduction datasets are present?
  #The data could be presented by PCA, TSNE, or UMAP dimensionality reduction.

colnames(colData(gut))
#Q.2.1:How many columns are there in colData(gut)?
  #This DataFrame has 39 columns.
#Q.2.2:Which three column names reported by colnames() seem most interesting?
  #I would say that "percent_mito" (column 16) is very interesting, as it may 
  #serve as important QC data. Additionally, "celda_decontx__doublemad_predicted_outliers"
  #(column 6) is interesting for a similar reason, but needs to be considered with data
  #in other columns in order to be applicable. Finally, most interesting I would 
  #say is column 37: "broad_annotation" which contains the cell type data.
#Q.2.3:Plot cells according to X_umap using plotReducedDim() and colouring by 
#broad_annotation.
  #set seed (for reproducibility) to run umap
set.seed(1234) 
  #run umap
plotReducedDim(gut, "X_umap", color="broad_annotation")


#sum up rows 
genecounts <- rowSums(assay(gut))
summary(genecounts)
#Q.3.1a:What is the mean and median gene-count according to summary()? 
  #The mean gene-count is 3185 and the median gene count is 254.
#Q.3.1b:What might you conclude from these numbers?
  #These numbers indicate a right skew of the data. The median is low, suggesting
  #most genes exhibit expression at this level. The mean is high, likely due to
  #some genes with very high expression levels driving this level up.
#Q.3.2a:What are the three genes with the highest expression after using sort()? 
#What do they share in common?
  #find max expressed gene
head(sort(genecounts, decreasing=TRUE))
  #The top three highest expressed genes are all RNA related. The top expressed gene
  #is lncRNA:Hsromega, the second is pre-rRNA:CR45845, and finally lncRNA:rox1.

cellcounts <- colSums(assay(gut))
hist(cellcounts)
summary(cellcounts)
#Q.4a.1:What is the mean number of counts per cell?
  #The mean number of counts per cell is 3622.
#Q.4a.2:How would you interpret the cells with much higher total counts (>10,000)?
  #These data include cell types of varying abundance, those with very high counts
  #are likely very common types (ex.epithelial).

celldetected <- colSums(assay(gut)>0)
hist(celldetected)
summary(celldetected)
#Q.4b.1:What is the mean number of genes detected per cell?
  #The mean number of genes detected per cell is 1059.
#Q.4b.2:What fraction of the total number of genes does this represent?
  #1059/13407 = 0.07899
  #1059 genes are 7.9% of the total unique genes detected

mito <- grep("^mt:", rownames(gut), value = TRUE)
df <- perCellQCMetrics(gut, subsets=list(Mito=mito))
df <- as.data.frame(df)
summary(df)
colData(gut) <- cbind(colData(gut), df)
colData(gut)
plotColData(object = gut,y = "subsets_Mito_percent",x = "broad_annotation") + 
  theme(axis.text.x=element_text(angle=90))
#Q.5:Which cell types may have a higher percentage of mitochondrial reads?
#Why might this be the case?
  #The cell types with the highest percentage of mitochondrial reads are the epithelial
  #and gut cells. This is likely due to their high energetic needs.

#Q.6a:Subset cells annotated as “epithelial cell”

coi <- colData(gut)$broad_annotation == "epithelial cell"
epi <- gut[,coi]
plotReducedDim(epi,"X_umap",color="annotation")

marker.info = scoreMarkers( epi, colData(epi)$annotation )
chosen <- marker.info[["enterocyte of anterior adult midgut epithelium"]]
ordered <- chosen[order(chosen$mean.AUC, decreasing=TRUE),]
head(ordered[,1:4])
#Q.6b.1:What are the six top marker genes in the anterior midgut? Based on their 
#functions at flybase.org, what macromolecule does this region of the gut appear 
#to specialize in metabolizing?
  #The top marker genes in the ant. midgut are Mal-A6, Men-b, vnd, betaTry, Mal-A1,
  #and Nhe2. These are all involved in carbohydrate metabolisis.

plotExpression(epi,c("Mal-A6","Men-b","vnd","betaTry","Mal-A1","Nhe2"),x="annotation") + 
  theme(axis.text.x=element_text(angle=90))
#Q.6b.2:Repeat the analysis for somatic precursor cells
coi2 <- colData(gut)$broad_annotation == "somatic precursor cell"
spc <- gut[,coi2]
spc.marker.info <- scoreMarkers(spc, colData(spc)$annotation)
chosen.spcs <- spc.marker.info[["intestinal stem cell"]]
ordered.spcs <- chosen.spcs[order(chosen.spcs$mean.AUC, decreasing=TRUE),]
head(ordered.spcs[,1:4])
  #The top marker genes in ISCs are hdc, kek5, N, zfh2, Tet, and Dl.

goi <- rownames(ordered.spcs)[1:6]
plotExpression(spc,goi,x="annotation") + theme(axis.text.x=element_text(angle=90))
#Q.7.1:Which two cell types have more similar expression based on these markers?
  #Enteroblasts and intestinal stem cells have very similar expression patterns, 
  #except in Dl. FlyBase returns two genes when searching "dl" but if this is in
  #reference to Delta, this is logical that it would be enriched in the more rapidly
  #proliferating stem cell population as Delta regulates cell fate/proliferation.
#Q.7.2:Which marker looks most specific for intestinal stem cells?
  #This Dl marker appears to be the most specific for intestinal stem cells.
