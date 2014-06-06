Community data modelling
========================================================



```r
library(ggplot2)
library(vegan)
```

```
## Loading required package: permute
## Loading required package: lattice
## This is vegan 2.0-10
```

```r
library(wesanderson)

## Read in Community matrix and format it 

# Read in csv for Community Matrix (not normalized)
class = read.csv("~/Documents/AllAntibiotic_Class_notNormalized_antibioticClass.csv")
dim(class)
```

```
## [1] 2111  200
```

```r
names(class)[1:10]
```

```
##  [1] "SampleID"               "Type"                  
##  [3] "Antibiotic"             "Class1"                
##  [5] "Class2"                 "Class3"                
##  [7] "ClassOther"             "X.S5_18."              
##  [9] "X.ABS_6."               "X.Acidobacteria_class."
```

```r
# Grab just numeric columns
classNumeric = class[,-1*c(1:7)]
# Eliminate columns that are all zeros
classNumeric=classNumeric[,colSums(classNumeric) !=0]
# Rebind string and numeric data into one dataframe
classDat = data.frame(class[,c(1:7)],classNumeric)
```



```r
## Read in genus data and format it (normalized)
genus = read.csv("~/Documents/AllAntibiotic_Genus.csv")
dim(genus)
```

```
## [1] 2111 1564
```

```r
names(genus)[1:10]
```

```
##  [1] "SampleID"          "Type"              "X.A17."           
##  [4] "X.Abies."          "X.Abiotrophia."    "X.Acanthamoeba."  
##  [7] "X.Acarosporina."   "X.Acaryochloris."  "X.Acetitomaculum."
## [10] "X.Acetivibrio."
```

```r
# Take only the numeric fields
genusNum = genus[c(-1,-2)]
# Get rid of fields that are 0
genusNum=genusNum[,colSums(genusNum) !=0]
# Scale everything to 1000 reads and round 
genusScale=apply(genusNum,1:2, function(x) 1e+03 * x)
genusScale = floor(genusScale)
# Rebind numeric and string data into one data frame
genusDat = data.frame(genus[,c(1,2)],genusScale)
```



```r
## Plot alpha diversity

# Plot alpha diversity for Genus
divG = data.frame(specnumber(genusScale))
colnames(divG) = "richness"
shannonG = data.frame(diversity(genusScale,index="shannon"))
colnames(shannonG) = "shannon"
type = genus[,2]
type=factor(type,levels(type)[c(4,2,1,5,3)])
shannonGplot=cbind(shannonG,type)
richnessGplot = data.frame(divG,type)

# Plot shannon diversity
ggplot(shannonGplot,aes(x=type,y=shannon,fill=type))+geom_boxplot()+ggtitle("Alpha diversity at genus level") + scale_fill_manual(values = wes.palette(5,"Darjeeling"))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-31.png) 

```r
# Do a t-test on just week and month
weekMonthIdx = shannonGplot$type == "week" | shannonGplot$type == "month"
weekMonth = shannonGplot[weekMonthIdx,]

t.test(weekMonth$shannon~weekMonth$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMonth$shannon by weekMonth$type
## t = -1.463, df = 58.7, p-value = 0.1487
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.41898  0.06503
## sample estimates:
##  mean in group week mean in group month 
##               1.442               1.619
```

```r
# Do a t-test on just week and multipleyear
weekMyearIdx = shannonGplot$type == "week" | shannonGplot$type == "multipleyear"
weekMyear = shannonGplot[weekMyearIdx,]

t.test(weekMyear$shannon~weekMyear$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMyear$shannon by weekMyear$type
## t = -1.148, df = 38.68, p-value = 0.258
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.34092  0.09409
## sample estimates:
##         mean in group week mean in group multipleyear 
##                      1.442                      1.565
```

```r
# Plot richness
ggplot(richnessGplot,aes(x=type,y=richness,fill=type))+geom_boxplot()+ggtitle("Alpha diversity at genus level") + xlab("") + ylab("richness") + scale_fill_manual(values = wes.palette(5,"Darjeeling"))
```

![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-32.png) 

```r
# Do a t-test on just week and month
weekMonthIdx = richnessGplot$type == "week" | richnessGplot$type == "month"
weekMonth = richnessGplot[weekMonthIdx,]

t.test(weekMonth$richness~weekMonth$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMonth$richness by weekMonth$type
## t = -2.457, df = 55.92, p-value = 0.01713
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -6.1202 -0.6229
## sample estimates:
##  mean in group week mean in group month 
##               16.29               19.66
```

```r
# Do a t-test on just week and myear
weekMyearIdx = richnessGplot$type == "week" | richnessGplot$type == "multipleyear"
weekMyear = richnessGplot[weekMyearIdx,]

t.test(weekMyear$richness~weekMyear$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMyear$richness by weekMyear$type
## t = -2.085, df = 38.67, p-value = 0.0437
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -5.08867 -0.07678
## sample estimates:
##         mean in group week mean in group multipleyear 
##                      16.29                      18.87
```
There is no significant difference in shannon's diversity between the week group and month group as well as wekk and multiple year group.

There is a significant difference in observed richness between the week group and the month group 

```r
# plot alpha diversity for class
divC = data.frame(specnumber(classNumeric))
colnames(divC) = "richness"
shannonC = data.frame(diversity(classNumeric,index="shannon"))
colnames(shannonC) = "shannon"
shannonCplot=cbind(shannonC,type)
richnessCplot = data.frame(divC,type)

# Plot shannon diversity
ggplot(shannonCplot,aes(x=type,y=shannon,fill=type))+geom_boxplot()+ggtitle("Alpha diversity at class level")+scale_fill_manual(values = wes.palette(5,"Darjeeling"))
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-41.png) 

```r
# t-test to see if week is different than month
weekMonthIdx = shannonCplot$type == "week" | shannonCplot$type == "month"
weekMonth = shannonCplot[weekMonthIdx,]

t.test(weekMonth$shannon~weekMonth$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMonth$shannon by weekMonth$type
## t = -1.504, df = 74.22, p-value = 0.1367
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.25165  0.03512
## sample estimates:
##  mean in group week mean in group month 
##              0.8627              0.9710
```

```r
# t-test to see if week is different than multipleyear
weekMyearIdx = shannonCplot$type == "week" | shannonCplot$type == "multipleyear"
weekMyear = shannonCplot[weekMyearIdx,]

t.test(weekMyear$shannon~weekMyear$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMyear$shannon by weekMyear$type
## t = -1.465, df = 38.89, p-value = 0.151
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -0.20450  0.03272
## sample estimates:
##         mean in group week mean in group multipleyear 
##                     0.8627                     0.9486
```

```r
ggplot(richnessCplot,aes(x=type,y=richness,fill=type))+geom_boxplot()+ggtitle("Alpha diversity at class level") + xlab("") + ylab("richness")+scale_fill_manual(values = wes.palette(5,"Darjeeling"))
```

![plot of chunk unnamed-chunk-4](figure/unnamed-chunk-42.png) 

```r
# Do a t-test on just week and month
weekMonthIdx = richnessCplot$type == "week" | richnessCplot$type == "month"
weekMonth = richnessCplot[weekMonthIdx,]

t.test(weekMonth$richness~weekMonth$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMonth$richness by weekMonth$type
## t = -0.6946, df = 50.2, p-value = 0.4905
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -2.286  1.111
## sample estimates:
##  mean in group week mean in group month 
##               9.921              10.508
```

```r
# Do a t-test on just week and myear
weekMyearIdx = richnessCplot$type == "week" | richnessCplot$type == "multipleyear"
weekMyear = richnessCplot[weekMyearIdx,]

t.test(weekMyear$richness~weekMyear$type)
```

```
## 
## 	Welch Two Sample t-test
## 
## data:  weekMyear$richness by weekMyear$type
## t = -1.42, df = 38.15, p-value = 0.1637
## alternative hypothesis: true difference in means is not equal to 0
## 95 percent confidence interval:
##  -2.7060  0.4747
## sample estimates:
##         mean in group week mean in group multipleyear 
##                      9.921                     11.037
```
No significant differences at the class level between the week and month or multipleyear

```r
## Filter data set 

## Class level
# Select only samples who have taken antibiotics in the past week 
weekIDX =  class$Type == "week" 
week = class[weekIDX,]
dim(week)
```

```
## [1]  38 200
```

```r
# There are 38 samples that are week

# Select only samples who have taken antibiotics in the past month
monthIdx = class$Type == "month"
month = class[monthIdx,]
dim(month)
```

```
## [1]  59 200
```

```r
# THere are 59 samples that are month so we want to subsample to have equal size groups
set.seed(1)
monthSampIdx = sample(59,38)
monthSamp = month[monthSampIdx,]
dim(monthSamp)
```

```
## [1]  38 200
```

```r
# Combine into one dataset called recent of just samples from the past week and month
recentClass = rbind(monthSamp,week)
rowSums(recentClass[,-1*c(1:7)])
```

```
##   286   292   303   321   282   319   326   305   327   274   281   279 
## 32000 24353 24981 28916 32594 13079 25984 23118 14801 15774 17813 13759 
##   323   288   322   328   301   312   329   302   307   318   295   275 
##  7400 33914 13286  7227 26712 21820 13618 17699 21712  5991 25228  7815 
##   280   284   271   283   297   324   304   287   299   306   291   298 
## 15324 32448 11793 42592 20615 22942 17914 43332 19572 27066 48444 16487 
##   289   273  2074  2075  2076  2077  2078  2079  2080  2081  2082  2083 
## 43086 27682 20939     0 20963 11663    25 36328 40741     3 38153 36808 
##  2084  2085  2086  2087  2088  2089  2090  2091  2092  2093  2094  2095 
## 14958 17384 12925   577 19265 17922 28285 12522 13694 18815     3 22724 
##  2096  2097  2098  2099  2100  2101  2102  2103  2104  2105  2106  2107 
## 14742  1112 29416 15811 20145  7387 15061  9815 12871  2210 37457  9707 
##  2108  2109  2110  2111 
## 16802 21648    17 29499
```

```r
row.names(recentClass)
```

```
##  [1] "286"  "292"  "303"  "321"  "282"  "319"  "326"  "305"  "327"  "274" 
## [11] "281"  "279"  "323"  "288"  "322"  "328"  "301"  "312"  "329"  "302" 
## [21] "307"  "318"  "295"  "275"  "280"  "284"  "271"  "283"  "297"  "324" 
## [31] "304"  "287"  "299"  "306"  "291"  "298"  "289"  "273"  "2074" "2075"
## [41] "2076" "2077" "2078" "2079" "2080" "2081" "2082" "2083" "2084" "2085"
## [51] "2086" "2087" "2088" "2089" "2090" "2091" "2092" "2093" "2094" "2095"
## [61] "2096" "2097" "2098" "2099" "2100" "2101" "2102" "2103" "2104" "2105"
## [71] "2106" "2107" "2108" "2109" "2110" "2111"
```

```r
recentClass = recentClass[-40,]

## Genus level
weekIDX =  genusDat$Type == "week" 
week = genusDat[weekIDX,]
dim(week)
```

```
## [1]  38 454
```

```r
# There are 38 samples that are week

# Select only samples who have taken antibiotics in the past month
monthIdx = genusDat$Type == "month"
month = genusDat[monthIdx,]
dim(month)
```

```
## [1]  59 454
```

```r
# THere are 59 samples that are month so we want to subsample to have equal size groups
monthSampIdx = sample(59,38)
monthSamp = month[monthSampIdx,]
dim(monthSamp)
```

```
## [1]  38 454
```

```r
# Combine into one dataset called recent of just samples from the past week and month
recentGenus = rbind(monthSamp,week)
```


```r
# Run random forests to see which factors separate these two groups
library(randomForest)
```

```
## randomForest 4.6-7
## Type rfNews() to see new features/changes/bug fixes.
```

```r
## Class level

# Get rid of extraneous columns
recentClassnum = recentClass[,-c(1:7)]

# Get rid of columns with all zeros
recentClassnum = recentClassnum[,colSums(recentClassnum) !=0]

# Normalize counts
classScale=t(apply(recentClassnum,1, function(x) 1e+03 * x/sum(x)))


# Add in factor of interest - in this case type
Type = recentClass$Type[drop=TRUE]
recentClassDat = data.frame(Type,recentClassnum)



# Run random forests
class.recent.rf <- randomForest(Type ~ ., data = recentClassDat, importance = TRUE, proximity = TRUE)
                                
print(class.recent.rf)
```

```
## 
## Call:
##  randomForest(formula = Type ~ ., data = recentClassDat, importance = TRUE,      proximity = TRUE) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 6
## 
##         OOB estimate of  error rate: 37.33%
## Confusion matrix:
##       month week class.error
## month    28   10      0.2632
## week     18   19      0.4865
```

```r
class.recent.mds <- cmdscale(1 - class.recent.rf$proximity, eig = TRUE)
varImpPlot(class.recent.rf)
```

![plot of chunk unnamed-chunk-6](figure/unnamed-chunk-6.png) 
The results from this random forest show that Bacteroidia, Erysipelotrichi, Fusobacteria, Gammaproteobacteria, clostridia, and Bacilli are the most important factors for accuracy in classification. 

We will now split our samples into train and test groups and use a support vector machine with this small set of factors to try to correctly classify our samples



```r
## Use SVM on training set to train model and then validate with test model
library(e1071)

# Select only the columns listed as important from random forests
colIdx = colnames(recentClassDat)== "X.Bacteroidia." | colnames(recentClassDat)=="X.Erysipelotrichi." | colnames(recentClassDat)== "X.Fusobacteria_class." | colnames(recentClassDat)== "X.Gammaproteobacteria."| colnames(recentClassDat)== "X.Clostridia."| colnames(recentClassDat) == "X.Bacilli."
type=recentClassDat[,1]
svmCtrim = data.frame(type,recentClassDat[,colIdx])
dim(svmCtrim)
```

```
## [1] 75  7
```

```r
# Number of repetitions
B=500
err=rep(0,B)

set.seed(3)

# Resample the test and train groups B times
for(b in 1:B){

# separate train and test groups using a 60/40 split
train=sample(nrow(svmCtrim),nrow(svmCtrim)*.6) 
trainset=svmCtrim[train,]
testset=svmCtrim[-train,]

# Fit the SVM
svmfit = svm(type~.,data=trainset,kernel="polynomial",cost=100,scale=TRUE)
# Predict with the testset
svm.pred <- predict(svmfit,testset[,-1])
# Calculate the error rate from the confusion table
errorTab = table(predict=svm.pred,truth=testset[,1])
err[b] = (errorTab[2]+errorTab[3])/sum(errorTab)
}

# Mean error across all repetitions
mean(err)
```

```
## [1] 0.4509
```

```r
# Lets plot the means of these classes between week and month
ggplot(svmCtrim, aes(x=type,y=X.Gammaproteobacteria.)) + geom_boxplot()
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-71.png) 

```r
ggplot(svmCtrim, aes(x=type,y=X.Clostridia.)) + geom_boxplot()
```

![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-72.png) 



```r
# Lets try modelling with genus

# Get rid of extraneous columns
recentGenusnum = recentGenus[,c(-1,-2)]

# Get rid of columns with all zeros
recentGenusnum = recentGenusnum[,colSums(recentGenusnum) !=0]
dim(recentGenusnum)
```

```
## [1]  76 122
```

```r
# Add in factor of interest - in this case type
Type = recentGenus$Type[drop=TRUE]
recentGenusDat = data.frame(Type,recentGenusnum)

# Run random forests
genus.recent.rf <- randomForest(Type ~ ., data = recentGenusDat, importance = TRUE, proximity = TRUE)

print(genus.recent.rf)
```

```
## 
## Call:
##  randomForest(formula = Type ~ ., data = recentGenusDat, importance = TRUE,      proximity = TRUE) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 11
## 
##         OOB estimate of  error rate: 36.84%
## Confusion matrix:
##       month week class.error
## month    22   16      0.4211
## week     12   26      0.3158
```

```r
genus.recent.mds <- cmdscale(1 - genus.recent.rf$proximity, eig = TRUE)
varImpPlot(genus.recent.rf,main="Random forests of genera associated with week and month classes",cex=.6)
```

![plot of chunk unnamed-chunk-8](figure/unnamed-chunk-8.png) 
 lets use Bacillus, Blautia, 313,323,604, and Allstipes



```r
## SVM 
library(e1071)

# Select only the columns listed as important from random forests
colIdx = colnames(recentGenusDat)== "X.604" | colnames(recentGenusDat)=="X.Blautia." | colnames(recentGenusDat)== "X.323" | colnames(recentGenusDat)== "X.Bacillus."| colnames(recentGenusDat)== "X.Alistipes."| colnames(recentGenusDat)== "X.313"
type=recentGenusDat[,1]
svmGtrim = data.frame(type,recentGenusDat[,colIdx])
dim(svmGtrim)
```

```
## [1] 76  7
```

```r
# Number of bootstraps
B=500
err=rep(0,B)

set.seed(3)

for(b in 1:B){

# separate train and test groups using a 60/40 split
train=sample(nrow(svmGtrim),nrow(svmGtrim)*.6) 
trainset=svmGtrim[train,]
testset=svmGtrim[-train,]

# Let's try svm
svmfit = svm(type~.,data=trainset,kernel="polynomial",cost=100,scale=TRUE)
svm.pred <- predict(svmfit,testset[,-1])
errorTab = table(predict=svm.pred,truth=testset[,1])
err[b] = (errorTab[2]+errorTab[3])/sum(errorTab)
}

mean(err)
```

```
## [1] 0.3769
```

```r
# Lets plot the means of these genera between week and month
ggplot(svmGtrim, aes(x=type,y=X.Blautia.)) + geom_boxplot()
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-91.png) 

```r
ggplot(svmGtrim, aes(x=type,y=X.323)) + geom_boxplot()
```

![plot of chunk unnamed-chunk-9](figure/unnamed-chunk-92.png) 


```r
# Lets look at categories of antibiotics

# Seperate Class 1's
class1Idx = recentClass$Class1 == 1
class1 = recentClass[class1Idx,]
class1$ClassOther = "Class1"

#Seperate Class 2's
class2Idx = recentClass$Class2 != 0
class2 =  recentClass[class2Idx,]
class2$ClassOther = "Class2"

# Rebind Class 1 and 2
classClass = rbind(class1,class2)
```


```r
library(ape)

# Hierarchical clustering by time since antibiotic use
bdist = vegdist(recentClassnum,method="bray")

hclust.bc = hclust(bdist,method="average")

colsType=c(rep("red",38),rep("blue",37))
plot(as.phylo(hclust.bc),direction="downwards",tip.color=colsType,cex=.7,)
legend("topleft","week","month")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-111.png) 

```r
# Hierarchical clustering by time since antibiotic class
recentclassClassnum = classClass[,-1*c(1:7)]
bdist = vegdist(recentclassClassnum,method="bray")

# Dendogram 
hclust.bc = hclust(bdist,method="average")
colsClass=c(rep("red",30),rep("blue",25))
plot(as.phylo(hclust.bc),direction="downwards",tip.color=cols,cex=.8,)
```

```
## Error: object 'cols' not found
```

```r
legend("topright",c("week","month"))
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-112.png) 

```r
# Bray curtis distance looking at 


comm.mds=metaMDS(recentclassClassnum,dist="bray")
```

```
## Square root transformation
## Wisconsin double standardization
## Run 0 stress 0.2037 
## Run 1 stress 0.2049 
## Run 2 stress 0.2055 
## Run 3 stress 0.2237 
## Run 4 stress 0.2049 
## Run 5 stress 0.2035 
## ... New best solution
## ... procrustes: rmse 0.005711  max resid 0.03181 
## Run 6 stress 0.2035 
## ... New best solution
## ... procrustes: rmse 0.001222  max resid 0.006342 
## *** Solution reached
```

```r
mds.fig = ordiplot(comm.mds,type="none")
points(mds.fig,"sites",pch=19,col="blue",select=classClass$ClassOther=="Class1")
points(mds.fig,"sites",pch=19,col="red",select=classClass$ClassOther=="Class2")
```

![plot of chunk unnamed-chunk-11](figure/unnamed-chunk-113.png) 

```r
adonis(bdist~Type,data=classClass)
```

```
## 
## Call:
## adonis(formula = bdist ~ Type, data = classClass) 
## 
## Terms added sequentially (first to last)
## 
##           Df SumsOfSqs MeanSqs F.Model    R2 Pr(>F)
## Type       1      0.26   0.261    1.21 0.022   0.27
## Residuals 53     11.48   0.216         0.978       
## Total     54     11.74                 1.000
```


```r
# Redo random forests

classClass$ClassOther <- as.factor(classClass$ClassOther)
classClassdat = classClass[,-c(1,3:6)]

# Run random forests
class.class.rf <- randomForest(ClassOther ~ ., data = classClassdat, importance = TRUE, proximity = TRUE)

print(class.class.rf)
```

```
## 
## Call:
##  randomForest(formula = ClassOther ~ ., data = classClassdat,      importance = TRUE, proximity = TRUE) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 13
## 
##         OOB estimate of  error rate: 34.55%
## Confusion matrix:
##        Class1 Class2 class.error
## Class1     26      4      0.1333
## Class2     15     10      0.6000
```

```r
class.class.mds <- cmdscale(1 - class.class.rf$proximity, eig = TRUE)
varImpPlot(class.class.rf)
```

![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12.png) 


```r
## Redo SVM with antibiotic classes

# Select only the columns listed as important from random forests
colIdx = colnames(classClassdat)== "X.Methanobacteria." | colnames(classClassdat)=="X.Clostridia." | colnames(classClassdat)== "X.Sphingobacteria." | colnames(classClassdat)== "X.Gammaproteobacteria."| colnames(classClassdat)== "X.Flavobacteria."| colnames(classClassdat) == "X.Fusobacteria_class."| colnames(classClassdat) == "X.Bacteroidia."
type=classClassdat[,2]
classClassNum = classClassdat[,-c(1,2)]
svmCtrim = data.frame(type,classClassdat[,colIdx])
dim(svmCtrim)
```

```
## [1] 55  8
```

```r
# Number of bootstraps
B=500
err=rep(0,B)

set.seed(3)

for(b in 1:B){

# separate train and test groups using a 60/40 split
train=sample(nrow(svmCtrim),nrow(svmCtrim)*.7) 
trainset=svmCtrim[train,]
testset=svmCtrim[-train,]

# Let's try svm
svmfit = svm(type~.,data=trainset,kernel="linear",cost=100,scale=TRUE)
svm.pred <- predict(svmfit,testset[,-1])
errorTab = table(predict=svm.pred,truth=testset[,1])
err[b] = (errorTab[2]+errorTab[3])/sum(errorTab)
}

mean(err)
```

```
## [1] 0.3241
```


```r
# Redo random forests

classClass$ClassOther <- as.factor(classClass$ClassOther)
classClassdat = classClass[,-c(1,3:6)]

# Run random forests
class.class.rf <- randomForest(ClassOther ~ ., data = classClassdat, importance = TRUE, proximity = TRUE)

print(class.class.rf)
```

```
## 
## Call:
##  randomForest(formula = ClassOther ~ ., data = classClassdat,      importance = TRUE, proximity = TRUE) 
##                Type of random forest: classification
##                      Number of trees: 500
## No. of variables tried at each split: 13
## 
##         OOB estimate of  error rate: 36.36%
## Confusion matrix:
##        Class1 Class2 class.error
## Class1     26      4      0.1333
## Class2     16      9      0.6400
```

```r
class.class.mds <- cmdscale(1 - class.class.rf$proximity, eig = TRUE)
varImpPlot(class.class.rf)
```

![plot of chunk unnamed-chunk-14](figure/unnamed-chunk-14.png) 

```r
## Redo SVM with antibiotic genera

# Select only the columns listed as important from random forests
colIdx = colnames(gendat)== "X.Methanobacteria." | colnames(classClassdat)=="X.Clostridia." | colnames(classClassdat)== "X.Sphingobacteria." | colnames(classClassdat)== "X.Gammaproteobacteria."| colnames(classClassdat)== "X.Flavobacteria."| colnames(classClassdat) == "X.Fusobacteria_class."| colnames(classClassdat) == "X.Bacteroidia."
```

```
## Error: object 'gendat' not found
```

```r
type=classClassdat[,2]
classClassNum = classClassdat[,-c(1,2)]
svmCtrim = data.frame(type,classClassdat[,colIdx])
dim(svmCtrim)
```

```
## [1] 55  8
```

```r
# Number of bootstraps
B=500
err=rep(0,B)

set.seed(3)

for(b in 1:B){

# separate train and test groups using a 60/40 split
train=sample(nrow(svmCtrim),nrow(svmCtrim)*.7) 
trainset=svmCtrim[train,]
testset=svmCtrim[-train,]

# Let's try svm
svmfit = svm(type~.,data=trainset,kernel="linear",cost=100,scale=TRUE)
svm.pred <- predict(svmfit,testset[,-1])
errorTab = table(predict=svm.pred,truth=testset[,1])
err[b] = (errorTab[2]+errorTab[3])/sum(errorTab)
}

mean(err)
```

```
## [1] 0.3241
```

```r
# Now with genera
```
