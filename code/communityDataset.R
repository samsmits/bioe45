# Read in csv
antiGH <- read.csv('~/Documents/antibiotic_GH_matrix.csv',sep=",",header=FALSE)
# Create vector to store rownames and add them to dataframe
label <- c(rep("week",37), rep("month",59), rep("sixmonth",255), rep("year",262))
antiGHdat = data.frame(label,antiGH)


# PRCOMP with GH
weekIdx =  antiGHdat$label == "year"
week <- antiGHdat[weekIdx,]
weeknum = antiGHdat[,c(-1,-2)]

notzero=weeknum[,colSums(weeknum^2) !=0]
classpca=prcomp(notzero[,c(-1,-2)],scale=TRUE)
biplot(classpca)


# Look at just week and year
weekAndYearIdx = antiGHdat$label == "week" | antiGHdat$label == "year"
subset <- antiGHdat[weekAndYearIdx,]
labs = antiGHdat[,1]
labs = labs[weekAndYearIdx,drop=TRUE]
subset[,1] = labs

# separate train and test groups using a 60/40 split
set.seed(3)
train=sample(nrow(subset),nrow(subset)*.6) 
trainset=subset[train,]
testset=subset[-train,]

# Lets try the lasso
library(glmnet)

# Format matrix and response for lasso
trainmat= as.matrix(trainset)[,-1]
response = trainset[,1]

# Fit lasso model 
lasso.fit = glmnet(trainmat,response,alpha=1,family="binomial")
plot(lasso.fit,xvar="lambda",label=TRUE,type.coef="coef")

# Use C.V. to find the best lambda
set.seed(1)
cv.out=cv.glmnet(antiGH,label,family="multinomial",type.multinomial="grouped",parallel=TRUE)
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam

#Find coefficients predicted for our best lambda
lasso.coef=predict(cv.out,s=bestlam,type="coefficient")
lasso.coef


########### Community data ##############
# Read in community data at class level
class = read.csv("~/Documents/AllAntibiotic_Class.csv")

# Read in community data at genus level
genus = read.csv("~/Documents/AllAntibiotic_Genus.csv",header=TRUE)

# Select only samples who have taken antibiotics in the past week or month 
# and categorize them as recent
recIDX =  class$Type == "week" | class$Type == "month"
recent = class[recIDX,]
# Grab just the numeric columns
recentnum = recent[,c(-1,-2)]
# Get rid of columns with all zeros
recnotzero = recentnum[,colSums(recentnum^2) !=0]
# Create a new label called month
lab = rep("month",nrow(recnotzero))
recentData = data.frame(lab,recnotzero)
nrow(recentData)
# We have 97 data points

# Select samples from the multiple year as control grop
multIDX = class$Type == "multipleyear"
mult = class[multIDX,]
# Grab just the numeric columns
multnum = mult[,c(-1,-2)]
# Get rid of columns with all zeros
multnotzero = multnum[,colSums(recentnum^2) !=0]
# Create label
lab = rep("multipleyear",nrow(multnotzero))
multData = data.frame(lab,multnotzero)
nrow(multData)
# sample 97 points from the control group
multSampIdx = sample(1471,97)
multSamp = multData[multSampIdx,]

# Combine into one data matrix
data= rbind(multSamp,recentData)

## Keep for later
# Store the labels ie week and year
# comLabel = subset[,2]
# comLabel = comLabel[drop=TRUE]

# Do principle components to see if samples can be clustered unsupervised by month and multiyear
classpca=prcomp(data[,-1],scale=FALSE)
biplot(classpca, cex=.5,xlabs=(c(rep("o",97), rep("x",97))),var.axes=TRUE,
       main="PCA of bacterial classes among samples \n with antiobiotic use in the past month vs multiyear \n \n")
legend("topright",c("x month","o multiyear"),cex=.5)

# Looks like they can't

# Do SVD to find the most influential classes
library()
dataNum = data[,-1]
lab = data[,1]
mostInf= getSvdMostInfluential(dataNum,quantile=.7,similarity_threshold=1)
mostInfIdx = mostInf$most_influential
mostInfIdx

# Trim class matrix to only these classes
classTrim = dataNum[mostInfIdx]
classTrim=cbind(lab,classTrim)

## Split into train and test groups
# separate train and test groups using a 75/25 split
set.seed(3)
train=sample(nrow(classTrim),nrow(classTrim)*.6) 
trainset=classTrim[train,]
testset=classTrim[-train,]

# Let's try svm
library(e1071)
svmfit = svm(lab~.,data=trainset,kernel="linear",cost=100,scale=TRUE)
svm.pred <- predict(svmfit,testset[,-1])
table(predict=svm.pred,truth=testset[,1])

# Format matrix and response for lasso
trainmat= trainset[,-1]
response = trainset[,1]

# Fit logistic regression

#Fit log regression using only training data
log2=glm(lab~.,data=trainset,family=binomial)

#Check to see what binary the computer has assigned each response to
contrasts(lab)

#Insert test data into model. 
log2.prob=predict(log2,testset[,-1],type="response")

#Create a vector of length of testset (5000), fill them with No's
#and switch to Yes's if the probability is above .5
log2.pred=rep("multipleyear",78)
log2.pred[log2.prob>.5]="month"

#Generate confusion table
table(predict=log2.pred,truth=testset[,1])
mean(log2.pred==default.test) # .9752

# Fit lasso model 
lasso.fit = glmnet(trainmat,response,alpha=1,family="binomial")
plot(lasso.fit,xvar="lambda",label=TRUE)

# Use C.V. to find the best lambda
set.seed(1)
cv.out=cv.glmnet(trainmat,response,family="binomial")
plot(cv.out)
bestlam=cv.out$lambda.min
bestlam

#Find coefficients predicted for our best lambda
lasso.coef=predict(cv.out,s=bestlam,type="coefficient")
lasso.coef





