library("phyloseq")
library("ggplot2")
setwd("~/bioe45/raw_communitydata/raw_agp/")

#Read in files for phyloseq object
otufile = "merged_agp_studies.biom"
mapfile = "gutmapping.txt"

#Import biomfile (there will be lots of warning messages)
biomdata = import_biom(otufile,parseFunction=parse_taxonomy_greengenes)
print(biomdata)
rank_names(biomdata)

# Import mapfile 
map = import_qiime_sample_data(mapfile)
merge = merge_phyloseq(biomdata,map)

#Prune taxa from the OTU table that are in zero samples
merge=prune_taxa(taxa_sums(merge)>0,merge)
merge

## Alpha diversity

# Richness histogram
obsRichness = estimate_richness(merge,measures="Observed")
hist(obsRichness$Observed, main="OTU richness in all samples (n=2035)",xlab="")

# Evenness histogram
obsEvenness = estimate_richness(merge,measures="Shannon")
hist(obsEvenness$Shannon,main="OTU evenness in all samples (n=2035)",xlab="Shannon diversity")

# Boxplot of richness and evenness
sample_data(merge)$Type <- factor(sample_data(merge)$Type,c("week","month","6month","year","multipleyear"))
plot_richness(merge,"Type",measures=c("Observed","Shannon"))+geom_boxplot()+xlab("")+ylab("  ")+ ggtitle("OTU alpha diversity in antibiotic groups")


## subsample from multiyear
# Select only multipleyear
multiIdx = sample_data(merge)$Type == "multipleyear"
multiFun = as.vector(multiIdx)

#Prune samples to only multiyear
multi=prune_samples(multiFun,merge)
multi
# There are 1422 samples that are multiyear
sampIdx = sample(1422,200)
samp=sample_data(multi)[sampIdx,]
id = as.vector(samp$X.SampleID)

# This is a new phyloseq object just with 200 multiyear
multSamp = prune_samples(id,merge)

# Select all non multiyear
idx = (sample_data(merge)$Type == "multipleyear" & sample_data(merge)$X.SampleID %in% id |sample_data(merge)$Type == "week") |
  sample_data(merge)$Type == "6month"|sample_data(merge)$Type == "month"|sample_data(merge)$Type == "year"
idxfun = as.vector(idx)
dataTrim = prune_samples(idx,merge)
dataTrim=prune_taxa(taxa_sums(dataTrim)>0,dataTrim)
dataTrim

# Select just past week and multiple year
idx = (sample_data(merge)$Type == "multipleyear" & sample_data(merge)$X.SampleID %in% id |sample_data(merge)$Type == "week") 
ixfun = as.vector(idx)
dataTrim = prune_samples(idx,merge)
dataTrim=prune_taxa(taxa_sums(dataTrim)>0,dataTrim)
dataTrim

# Trim out OTU's that have a mean less than 1% 
#Normalize to 1 read per sample (proportions)
dataTmean = transform_sample_counts(dataTrim, function(x){x/sum(x)})

#Set threshold to filter OTUs
thresh = .01

#Filter OTUs with a mean proportion below the threshold
otu_table(dataTmean)[otu_table(dataTmean)<thresh] <-0

zero_samples=which(taxa_sums(dataTmean)==0)
length(zero_samples)
#Prune taxa from the OTU table that are in zero samples
dataTmean=prune_taxa(taxa_sums(dataTmean)>0,dataTmean)
dataTmean

## There are only 748 taxa that have a mean above 1% across all samples


# Transform to 1000 reads per sample
dataTmean=transform_sample_counts(dataTmean,function(x) 1e+03 * x/sum(x))
otu_table(dataTmean) = floor(otu_table(dataTmean))


## Beta diversity
library(doParallel)
registerDoParallel(makeCluster(2))
bdist = phyloseq::distance(dataTmean,"bray")
bray.P=ordinate(dataTrim,method="PCoA",bdist)
sample_data(dataTmean)$Type <- factor(sample_data(dataTmean)$Type,c("week","month","6month","year","multipleyear"))
plot_ordination(dataTmean,bray.P,color="Type") + geom_point(size=3) + ggtitle("PCoA of Antibiotic classes")

## random forest
library(randomForest)

otu = data.frame(otu_table(dataTmean))
otu = t(otu)
type = sample_data(dataTmean)$Type
otu.df= data.frame(type,otu)
antibio.rf <- randomForest(type ~ ., data = otu.df, importance = TRUE, 
                                proximity = TRUE)
print(antibio.rf)


antibio.mds <- cmdscale(1 - antibio.rf$proximity, eig = TRUE)
varImpPlot(antibio.rf)

## Random forests on GH
antiGH.rf <- randomForest(label ~ ., data = antiGHdat, importance = TRUE, 
                           proximity = TRUE)
print(antiGH.rf)
antiGH.mds <- cmdscale(1 - antiGH.rf$proximity, eig = TRUE)
varImpPlot(antiGH.rf)

