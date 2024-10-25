install.packages("ggfortify")
install.packages("hexbin")

library(DESeq2)
library(vsn)
library(matrixStats)
library(readr)
library(dplyr)
library(tibble)
library(hexbin)
library(ggfortify)

sessionInfo()

#3.1 - loading and filtering the data
#Open data file (i think this is the right one?)
data = readr::read_tsv("salmon.merged.gene_counts.tsv")
#The first column, containing the names of genes, should be used as the names of rows
#so, first we will re-orient the data in the first column and give it a variable name.
data = column_to_rownames(data, var ="gene_name")
#remove gene_id as this is now redundant
data = data %>% dplyr::select(-gene_id)
#convert from numbers to integers for DESeq2.
data = data %>% dplyr::mutate_if(is.numeric, as.integer)
#filter low expression genes (across entire data set)
data = data[rowSums(data) > 100,]
#select broad samples
broad = data%>% dplyr::select("A1-3_Rep1":"P1-4_Rep3")
#3.2 - creating DESeq model and batch correlation
#make metadata, differentiating both between tissues and replicates.
metadata = tibble(tissue=c("A1-3", "A1-3", "A1-3", "CuLFCFe", "CuLFCFe",
                           "CuLFCFe", "P1-4", "P1-4", "P1-4"),
                  rep=c("Rep1", "Rep2", "Rep3", 
                        "Rep1", "Rep2", "Rep3",
                        "Rep1", "Rep2", "Rep3"))
ddsBroad = DESeqDataSetFromMatrix(countData = broad, colData = metadata,
                                  design=~tissue)
#look at mean by variance
meanSdPlot(assay(ddsBroad))
#log transform of data
logBroad = normTransform(ddsBroad)
#look at log mean by variance
meanSdPlot(assay(logBroad))
#apply vst (variance stabilizing transform)
vstBroad = vst(ddsBroad)
#finally, look at VST mean by variance
meanSdPlot(assay(vstBroad))

#3.3 - PCA on corrected data

#perform PCA on VST transformed data 
vstPCAdata = plotPCA(vstBroad, 
                     intgroup=c('rep','tissue'), returnData=TRUE)
ggplot(vstPCAdata, mapping = aes(PC1, PC2, color=tissue, shape=rep)) +
  geom_point(size=5)

#3.4 - filter genes by variance
matBroad = as.matrix(assay(vstBroad))
acombined = matBroad[,seq(1,9,3)]
combined = combined + matBroad[,seq(2,9,3)]
combined = combined + matBroad[,seq(3,9,3)]
combined = combined/3
filt = rowSds(combined) > 1

#3.5 - use k-means variance to sort/cluster the data
#first set heatmap as way of presenting data.
#then proceed with clustering, and applying that to mapped data
matBroad = matBroad[filt,]
heatmap(matBroad, Colv=NA)
set.seed(42)
k=kmeans(matBroad, centers=12)$cluster
ordering = order(k)
k=k[ordering]
matBroad = matBroad[ordering,]
heatmap(matBroad, Rowv=NA, Colv=NA, 
        RowSideColors=RColorBrewer::brewer.pal(12,"Paired")[k])
genes = rownames(matBroad[k==2,])
write.table(genes, 'cluster2.txt', sep="\n", quote=FALSE, 
            row.names=FALSE, col.names=FALSE)

