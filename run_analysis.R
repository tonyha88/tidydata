##  R script file to create the tidy data set.

#setwd("F:\\Coursera\\Getting and Cleaning Data -JeffLeek (JohnsHopkins)\\PA")
#source("./run_analysis.R")
#It is assumed that you are in the working directory that contains Samsung data directory called "UCI HAR Dataset".
#
##1. Merges the training and the test sets to create one data set.
testdata <- read.table("./UCI HAR Dataset/test/X_test.txt")
testdatay <- read.table("./UCI HAR Dataset/test/y_test.txt")
names(testdatay) <- c("V562")
testdata <- cbind(testdata, testdatay)
dim(testdata) #[1] 2947  562
traindata <- read.table("./UCI HAR Dataset/train/X_train.txt")
traindatay <- read.table("./UCI HAR Dataset/train/y_train.txt")
names(traindatay) <- c("V562")
traindata <- cbind(traindata, traindatay)
dim(traindata) #[1] 7352  562

data <- rbind(traindata, testdata)
dim(data) #[1] 10299   562

##4. Appropriately labels the data set with descriptive variable or feature (column) names"
header <- read.table("./UCI HAR Dataset/features.txt")
headeronly <- header[ ,"V2"]
names(data) <- headeronly
names(data)[562] <- "activity"

##2. Extracts only the measurements on the mean and standard deviation for each measurement.
datamean <- data[, grep("mean()", colnames(data), value=TRUE, fixed = TRUE)]
datastd <- data[, grep("std()", colnames(data), value=TRUE)]
datameanstd  <-cbind(datamean, datastd)
dim(datameanstd) #[1] 10299    66

##3. Uses descriptive activity names to name the activities in the data set
activity <- data[, "activity"]
datameanstd <-cbind(datameanstd, activity)
dim(datameanstd) #[1] 10299    67

datameanstd$activity <- gsub("1", "WALKING", datameanstd$activity)
datameanstd$activity <- gsub("2", "WALKING_UPSTAIRS", datameanstd$activity)
datameanstd$activity <- gsub("3", "WALKING_DOWNSTAIRS", datameanstd$activity)
datameanstd$activity <- gsub("4", "SITTING", datameanstd$activity)
datameanstd$activity <- gsub("5", "STANDING", datameanstd$activity)
datameanstd$activity <- gsub("6", "LAYING", datameanstd$activity)


##5. Creates a second, independent tidy data set with the average of each variable for each
# activity and each subject.

library(reshape2)
testsubject <- read.table("./UCI HAR Dataset/test/subject_test.txt")
trainsubject <- read.table("./UCI HAR Dataset/train/subject_train.txt")

datasubject <- rbind(trainsubject, testsubject)
dim(datasubject) #[1] 10299     1
tidydata <- cbind(datasubject, datameanstd)
dim(tidydata) #[1] 10299    68
names(tidydata)[1] <- "subject"
names(tidydata)[68] <- "activity"

tidydata <- melt(tidydata, id.vars = c("activity", "subject"))
tidydata <- dcast(tidydata, activity + subject ~ variable, fun.aggregate = mean, na.rm = TRUE)

dim(tidydata) #[1] 180  68
write.csv(tidydata, "tidydata.txt")

