# datasciencecoursera Machine learning Final Project

library('caret')
## Load training data 

filename<-"training_clean.csv"
training<-read.csv(filename)

## Clean training data

# remove index/time stamp col
training_rm<-training[-c(1, 3:5)]

## Remove columns with missing values
training_col<-training[,colSums(is.na(training)) == 0]
training_clean<-training_col[,colSums(training_col=="")==0]

head(training_col)
dim(training_col)

## Check class
sapply(training,class)

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

## testing lda model

filename<-"pml-testing.csv"
testing<-read.csv(filename)

testing_col<-testing[,colSums(is.na(testing)) == 0]
testing_col<-testing_col[,colSums(testing_col=="")==0]

pred_lda<-predict(mod_lda, testing_col)

pred_lda
