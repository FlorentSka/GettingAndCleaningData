#As per instructions, we assume we are working in the same directory where the Samsung files have been downloaded and unziped.

#Before the work starts, packages data.table and dplyr will have to be installed
library(data.table)
library(dplyr)

#read generic information tables
activityLabels<-read.table("./activity_labels.txt")
vectorFeatures<-read.table("./features.txt")

# Reading, naming and preparing the Test set
subjectsTest<-read.table("./test/subject_test.txt", header=FALSE)
colnames(subjectsTest)<-"Subjects"
testLabels<-read.table("./test/y_test.txt", header=FALSE)
colnames(testLabels)<-"Activity"
testSet<-read.table("./test/X_test.txt", header=FALSE)
colnames(testSet)<- vectorFeatures[,2]

fullTestSet<-cbind(subjectsTest, testLabels, testSet)

# Reading, naming and preparing the Training set
subjectsTrain<-read.table("./train/subject_train.txt", header=FALSE)
colnames(subjectsTrain)<-"Subjects"
trainLabels<-read.table("./train/y_train.txt", header=FALSE)
colnames(trainLabels)<-"Activity"
trainSet<-read.table("./train/X_train.txt", header=FALSE)
colnames(trainSet)<- vectorFeatures[,2]

fullTrainSet<-cbind(subjectsTrain, trainLabels, trainSet)

#Merging Test and Train sets: the full set has:
#1st column with the Subject
#2nd column with the Activity
#columns 3 to 563 contain the 561 measurements
fullSet<-rbind(fullTestSet, fullTrainSet)

#Extracting only the columns with means and standard deviations

#Select the columns numbers of fullSet that contain the strings "Mean" and "Std"
meanStdColumns <- grep(".*Mean.*|.*Std.*", names(fullSet), ignore.case=TRUE)

#Create a vector with all the columns of interest: Subject, Activity, Means and Stds columns
columns <- c(1,2,meanStdColumns)

#Subset the fullSet to only the columns of interest
meanStdSet<-fullSet[,columns]

#Convert the Activity (2nd) column into characters
meanStdSet[,2]<-as.character(meanStdSet[,2])
for (i in 1:6){
  meanStdSet[,2][meanStdSet[,2] == i] <- as.character(activityLabels[i,2])
}

#Replacing abbreviations by explicit measurement names
#Readable with capital letters
#Avoid unuseful symbols

#prefix 't' stands for Time (replace the letter t only when it's in the first position)
#also when its preceded by a '(' in the angle
names(meanStdSet)<-gsub("^t", "Time", names(meanStdSet))
names(meanStdSet)<-gsub("\\(t", "(Time", names(meanStdSet))
#'Freq' stands for Frequence
names(meanStdSet)<-gsub("Freq", "Frequence", names(meanStdSet))
#prefix 'f' stands for Frequency (replace the letter f only when it's in the first position)
names(meanStdSet)<-gsub("^f", "Frequency", names(meanStdSet))
#'Acc' stands for Accelerometer
names(meanStdSet)<-gsub("Acc", "Accelerometer", names(meanStdSet))
#'Gyro' stands for Gyroscope
names(meanStdSet)<-gsub("Gyro", "Gyroscope", names(meanStdSet))
#'Mag' stands for Magnitude
names(meanStdSet)<-gsub("Mag", "Magnitude", names(meanStdSet))
#Eliminate unused parts: double parentheses and hiphens as well as double "Body"
names(meanStdSet)<-gsub("\\(\\)", "", names(meanStdSet))
names(meanStdSet)<-gsub("-", "", names(meanStdSet))
names(meanStdSet)<-gsub("BodyBody", "Body", names(meanStdSet))
#Capitalize Mean, Std, Gravity and Angle
names(meanStdSet)<-gsub("mean", "Mean", names(meanStdSet))
names(meanStdSet)<-gsub("std", "Std", names(meanStdSet))
names(meanStdSet)<-gsub("angle", "Angle", names(meanStdSet))
names(meanStdSet)<-gsub("gravity", "Gravity", names(meanStdSet))

#Rename the set
set<-meanStdSet

#Turn Subject and Activity into factors and turn into data table
set$Subjects<-as.factor(set$Subjects)
set$Activity<-as.factor(set$Activity)
set <- data.table(set)

#Creating a new set with the calculation of the mean per subject and activity
tidySet <- aggregate(. ~Subjects + Activity, set, mean)
#Order the set per Subject and Activity
tidySet <- tidySet[order(tidySet$Subjects,tidySet$Activity),]

#Finalization with exportation of a new data set text file entitle tidySet.txt
#Take out the inherited row names that are unuseful
write.table(tidySet, file = "tidySet.txt", row.names = FALSE)