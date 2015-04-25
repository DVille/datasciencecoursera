library(data.table)

#You should create one R script called run_analysis.R that does the following. 
#1. Merges the training and the test sets to create one data set.
#2. Extracts only the measurements on the mean and standard deviation for each measurement. 
#3. Uses descriptive activity names to name the activities in the data set
#4. Appropriately labels the data set with descriptive variable names. 
#5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

# Preparation: Download/Unzip test and training sets and  activities

downloadFile <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Data.zip"
download.file(downloadFile, destfile = "Data.zip")
unzip("Data.zip")

# Get activity names from appropriate files
activities <- read.table("./UCI HAR Dataset/activity_labels.txt",header=FALSE,colClasses="character")
test_y_test$V1 <- factor(test_y_test$V1,levels=activities$V1,labels=activities$V2)
train_y_train$V1 <- factor(train_y_train$V1,levels=activities$V1,labels=activities$V2)

#Get Data
test_x_test <- read.table("./UCI HAR Dataset/test/X_test.txt",header=FALSE)
test_y_test <- read.table("./UCI HAR Dataset/test/y_test.txt",header=FALSE)
test_subj_test <- read.table("./UCI HAR Dataset/test/subject_test.txt",header=FALSE)
trainData <- read.table("./UCI HAR Dataset/train/X_train.txt",header=FALSE)
train_y_train <- read.table("./UCI HAR Dataset/train/y_train.txt",header=FALSE)
train_sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt",header=FALSE)

# Edit column names to reflect values from previous steps
features <- read.table("./UCI HAR Dataset/features.txt",header=FALSE,colClasses="character")
colnames(test_x_test)<-features$V2
colnames(trainData)<-features$V2
colnames(test_y_test)<-c("Activity")
colnames(train_y_train)<-c("Activity")
colnames(test_subj_test)<-c("Subject")
colnames(train_sub_train)<-c("Subject")

# Merge training sets now that the columns are the same
test_x_test<-cbind(test_x_test,test_y_test)
test_x_test<-cbind(test_x_test,test_subj_test)
trainData<-cbind(trainData,train_y_train)
trainData<-cbind(trainData,train_sub_train)
FullSet<-rbind(test_x_test,trainData)

# Extract mean and standard deviation from data
FullSet_mean<-sapply(FullSet,mean,na.rm=TRUE)
FullSet_SD<-sapply(FullSet,sd,na.rm=TRUE)

# Creates a second, tidy data set with the average of each variable for various criteria
DT <- data.table(FullSet)
tidy<-DT[,lapply(.SD,mean),by="Activity,Subject"]
write.table(tidy,file="DVtidy.txt",sep=",",row.names = FALSE)