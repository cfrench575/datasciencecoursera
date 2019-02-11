## R getting and cleaning data course project
library(plyr)
library(dplyr)
library(tidyr)

# training data:
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")

# testing data
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")

# features
features <- read.table('UCI HAR Dataset/features.txt')

# activity labels
activityLabels = read.table('UCI HAR Dataset/activity_labels.txt')


#variable names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

##merging data files

train_all <- cbind(y_train, subject_train, x_train)
test_all <- cbind(y_test, subject_test, x_test)

##merge training and test set
Data <- join(train_all, test_all)
Data1<-as.data.frame(Data)


##extracts measures containing mean and standard deviation

Data2<-bind_rows(Data1)


Data_meansd<- dplyr::select(Data2, activityId, subjectId, contains("mean"), contains("std"))


##adds on descriptive labels 

Data_meansd1 <- join(Data_meansd, activityLabels)

###Second dataset with means
Data_meansd1$activityId<- as.factor(Data_meansd1$activityId)
Data_meansd1$subjectId<- as.factor(Data_meansd1$subjectId)


AVG_Data <-aggregate(Data_meansd1, by=list(Data_meansd1$activityId,Data_meansd1$subjectId), 
                    FUN=mean, na.rm=TRUE)

AVG_Data1<- AVG_Data %>%
  select(-activityId, -subjectId, -activityType)

AVG_Data1$activityId<- AVG_Data1$Group.1
AVG_Data1$subjectId<-AVG_Data1$Group.2

AVG_Data2 <- join(AVG_Data1, activityLabels)


AVG_Data3<- AVG_Data2 %>%
  select(-Group.1, -Group.2)

##write dataset

write.table(means_data, "AVG_Data3.txt", row.name=FALSE)




