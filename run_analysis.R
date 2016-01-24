
#1.Merges the training and the test sets to create one data set.
#2.Extracts only the measurements on the mean and standard deviation for each measurement. 
#3.Uses descriptive activity names to name the activities in the data set
#4.Appropriately labels the data set with descriptive variable names. 
#5.From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#change working directory
setwd("C:/Users/William/Box Sync/Coursera/Getting Cleaning Data/GettingCleaningData/getdata_projectfiles_UCI HAR Dataset/UCI HAR Dataset")
library(dplyr)
library(tidyr)
library(stringr)
# import the training data and response variables
datatrain<-read.table("train/X_train.txt",header=F,sep="")
resptrain<-read.table("train/y_train.txt",header=F,sep="")

#import the variable names
vars<-read.table("features.txt",header=F,sep="")
varsA<-read.table("activity_labels.txt",header=F,sep="")

#attach names to training dataset
names(datatrain)<- vars$V2
datatrain$activity<-factor(x=resptrain$V1,levels=c(1,2,3,4,5,6),labels=varsA$V2)
subjecttrain<-read.table("train/subject_train.txt",header=F,sep="")
datatrain$subject<-factor(subjecttrain$V1,levels=seq(1,30,1))


#import the test data and attach names to test dataset
datatest<-read.table("test/X_test.txt",header=F,sep="")
resptest<-read.table("test/y_test.txt",header=F,sep="")
names(datatest)<- vars$V2
datatest$activity<-factor(x=resptest$V1,levels=c(1,2,3,4,5,6),labels=varsA$V2)
subjecttest<-read.table("test/subject_test.txt",header=F,sep="")
datatest$subject<-factor(subjecttest$V1,levels=seq(1,30,1))

#merge training and test datasets
data<-bind_rows(datatrain,datatest)

#get the mean and stdev columns only (and the activity and subject variables)
data2<-select(data,matches(".mean.|.std.|activity|subject"))


#dataset with average per subject per activity, summary 
tidy<-select(data2,-contains("angle") )%>% group_by(activity,subject) %>% summarise_each(funs(mean))

#start creating tidy datasets, with columns put into rows where relevat
tidy2<-gather(tidy, key,value,-activity,-subject) %>%
  mutate(dashCount=str_count(key,"-")) %>%
  mutate(key2=ifelse(dashCount ==2,as.character(key),paste0(as.character(key),"-"))) #count number of dashes

tidy3<-separate(tidy2,key2,into = c("action", "measure","coordinate"), sep="-") #separate the key variable into other varaibles
tidy4<-separate(tidy3,action,into = c("t_f","action"),sep=1) %>% 
  select(-c(key,dashCount))

#final cleaning - convert to factors
tidy4$t_f <- as.factor(tidy4$t_f)
tidy4$action <- as.factor(tidy4$action)
tidy4$coordinate <- as.factor(tidy4$coordinate)
tidy4$measure <- as.factor(tidy4$measure)
str(tidy4)
write.table(tidy4,"tidydata.txt",row.names=FALSE)
