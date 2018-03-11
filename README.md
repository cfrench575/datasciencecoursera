# datasciencecoursera Machine learning Final Project

library('caret')
## Load training data 


filename<-"training_clean.csv"
training<-read.csv(filename)


## Clean training data

## Remove columns with missing values
training_col<-training[,colSums(is.na(training)) == 0]
head(training_col)
dim(training_col)

## Check class
sapply(training,class)

## Remove variables with correlation coefficient greater than .8
train_cor=cor(training_col[sapply(training_col, is.numeric)]) 
abs(train_cor)
hc = findCorrelation(train_cor, cutoff=0.8) 
hc = sort(hc) 
training_clean = training_col[,-c(hc)] 
head (training_clean)
dim(training_clean)

## Subset into training and validation
inTrain<-createDataPartition(y=training_clean$classe, p=0.7,list=FALSE)
trainingSub<-training_clean[inTrain,]
validationSub<-training_clean[-inTrain,]

## use 10-fold cross validation
control <- trainControl(method="cv", number=10)

## create lda model
mod_lda=train(classe~.,data=trainingSub,method="lda", trControl=control)
## predictions for validation data
pred_lda<-predict(mod_lda, validationSub)
confusionMatrix(pred_lda, validationSub$classe)

