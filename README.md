# GettingAndCleaningData
Course Project for Data Science John Hopkins University 3rd course unit

##Preliminary Requirements

###Access
Get access to the local directory where downloaded files are located.
In this case, the directory is:
setwd("C:/Users/Florent/Desktop/MOOC/Getting and Cleaning Data/Prog Assignment/Data")

###Libraries
Before the work starts, Packages data.table and dplyr will have to be installed.
They are then loaded with the following:
library(data.table)
library(dplyr)

###Start analysis with reading generic information
Read generic information tables containing the labels of the activities and the measured elements:
activityLabels<-read.table("./activity_labels.txt")
vectorFeatures<-read.table("./features.txt")

##Part 1 - Merge the training and the test sets into one data set.

### Reading, naming and preparing the Test sets
subjectsTest<-read.table("./test/subject_test.txt", header=FALSE)
colnames(subjectsTest)<-"Subjects"
testLabels<-read.table("./test/y_test.txt", header=FALSE)
colnames(testLabels)<-"Activity"
testSet<-read.table("./test/X_test.txt", header=FALSE)
colnames(testSet)<- vectorFeatures[,2]

###Combine into one full Test set

fullTestSet<-cbind(subjectsTest, testLabels, testSet)

### Reading, naming and preparing the Training sets
subjectsTrain<-read.table("./train/subject_train.txt", header=FALSE)
colnames(subjectsTrain)<-"Subjects"
trainLabels<-read.table("./train/y_train.txt", header=FALSE)
colnames(trainLabels)<-"Activity"
trainSet<-read.table("./train/X_train.txt", header=FALSE)
colnames(trainSet)<- vectorFeatures[,2]

###Combine into one full Train set
fullTrainSet<-cbind(subjectsTrain, trainLabels, trainSet)

###Merging Test and Train sets: the full set has:
*1st column with the Subject
*2nd column with the Activity
*columns 3 to 563 contain the 561 measurements
fullSet<-rbind(fullTestSet, fullTrainSet)

##Part 2 - Extracting only the columns with means and standard deviations

###Select the columns numbers of fullSet that contain the strings "Mean" and "Std"
meanStdColumns <- grep(".*Mean.*|.*Std.*", names(fullSet), ignore.case=TRUE)

###Create a vector with all the columns of interest: Subject, Activity, Means and Stds columns
columns <- c(1,2,meanStdColumns)

###Subset the fullSet to only the columns of interest
meanStdSet<-fullSet[,columns]

##Part 3 - Giving explicit names to activities

###Convert the Activity (2nd) column into characters and replace corresponding numbers to activities names
meanStdSet[,2]<-as.character(meanStdSet[,2])
for (i in 1:6){
  meanStdSet[,2][meanStdSet[,2] == i] <- as.character(activityLabels[i,2])
}

##Part 4 - Giving appropriate explicit labels to variables

We will replace abbreviations by explicit measurement names, readable with capital letters. Also avoid unuseful symbols.

*prefix 't' stands for Time (replace the letter t only when it's in the first position). Also when its preceded by a '(' in the angle:
names(meanStdSet)<-gsub("^t", "Time", names(meanStdSet))
names(meanStdSet)<-gsub("\\(t", "(Time", names(meanStdSet))
*'Freq' stands for Frequence
names(meanStdSet)<-gsub("Freq", "Frequence", names(meanStdSet))
*prefix 'f' stands for Frequency (replace the letter f only when it's in the first position)
names(meanStdSet)<-gsub("^f", "Frequency", names(meanStdSet))
*'Acc' stands for Accelerometer
names(meanStdSet)<-gsub("Acc", "Accelerometer", names(meanStdSet))
*'Gyro' stands for Gyroscope
names(meanStdSet)<-gsub("Gyro", "Gyroscope", names(meanStdSet))
*'Mag' stands for Magnitude
names(meanStdSet)<-gsub("Mag", "Magnitude", names(meanStdSet))
*Eliminate unused parts: double parentheses and hiphens as well as double "Body"
names(meanStdSet)<-gsub("\\(\\)", "", names(meanStdSet))
names(meanStdSet)<-gsub("-", "", names(meanStdSet))
names(meanStdSet)<-gsub("BodyBody", "Body", names(meanStdSet))
*Capitalize Mean, Std, Gravity and Angle
names(meanStdSet)<-gsub("mean", "Mean", names(meanStdSet))
names(meanStdSet)<-gsub("std", "Std", names(meanStdSet))
names(meanStdSet)<-gsub("angle", "Angle", names(meanStdSet))
names(meanStdSet)<-gsub("gravity", "Gravity", names(meanStdSet))

###Rename the set
set<-meanStdSet

##Part 5 - Create a new tidy set with the mean of each variable per subject and activity

###Turn Subject and Activity into factors and turn the set into data table
set$Subjects<-as.factor(set$Subjects)
set$Activity<-as.factor(set$Activity)
set <- data.table(set)

###Create a new set with the calculation of the mean per subject and activity
tidySet <- aggregate(. ~Subjects + Activity, set, mean)

###Order the set per Subject and Activity
tidySet <- tidySet[order(tidySet$Subjects,tidySet$Activity),]

###Finalization
Exportation of a new data set text file entitle tidySet.txt
Take out the inherited row names that are unuseful (required in the assignment).
write.table(tidySet, file = "tidySet.txt", row.names = FALSE)
