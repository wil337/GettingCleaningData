
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)
#1. merge training and test sets
datatrain<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/X_train.txt",header=F,sep="")
vars<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/features.txt",header=F,sep="")
#4. labels

resptrain<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/y_train.txt",header=F,sep="")
varsA<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/activity_labels.txt",header=F,sep="")
#3. name activities
datatrain$activity<-factor(x=resptrain$V1,levels=c(1,2,3,4,5,6),labels=varsA$V2)
subjecttrain<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/train/subject_train.txt",header=F,sep="")
datatrain$subject<-factor(subjecttrain$V1,levels=seq(1,30,1))

datatest<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/X_test.txt",header=F,sep="")
resptest<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/y_test.txt",header=F,sep="")
datatest$activity<-factor(x=resptest$V1,levels=c(1,2,3,4,5,6),labels=varsA$V2)
subjecttest<-read.table("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset/test/subject_test.txt",header=F,sep="")
datatest$subject<-factor(subjecttest$V1,levels=seq(1,30,1))

data<-bind_rows(datatrain,datatest)
str(datatrain2)

#2. mean and stdev
data2<-select(data,matches(".mean.|.std.|activity|subject"))


#5. average per subject per activity, summary 
tidy<-select(data2,-matches(".std.")) %>% group_by(activity,subject) %>% summarise_each(funs(mean))

