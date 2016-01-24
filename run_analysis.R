
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

data <- read.table(unz("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", "Sales.dat"), nrows=10, header=T, quote="\"", sep=",")
?unz

unzip<-unz("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip","/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt")
train<- read.table(unzip,header=FALSE)
close(unzip)

#1. merge training and test sets
datatrain<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",header=F,sep="")
vars<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt",header=F,sep="")
names(datatrain)<- gsub("()","",vars$V2)
datatest<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",header=F,sep="")
names(datatest)<- gsub("()","",vars$V2)
data<-bind_rows(datatrain,datatest)
names(data)
#2. mean and stdev
library(dplyr)
data2<-select(data,matches(".mean.|.std"))
