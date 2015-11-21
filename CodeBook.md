#Code Book for the Getting and Cleaning Data Course Project

##Objective
This Code Book explains how we have created a tidy data set from wearable computing data that is ready to be analyzed.
It describes the variables, the data, and the transformations that are performed to clean up the data through the script run_analysis.R

##Data Source

The data used has been collected from the accelerometers from the Samsung Galaxy S smartphone.
It was recorded by the Universitat Politecnica de Catalunya, and was downloaded from UCI Machine Learning Repository:
https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The original code book for the data source can be found here:
http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones 

##Preliminary
The zip file was downloaded and unzipped into a local directory.
First observations were made by reading the two reference data tables:
* activity_labels.txt: the list of activities that the 30 subjects were asked to perform
* features.txt: the vectorized list of measurements that were recorded.

##Processing data

###Creation of a working set

####Test Set
a. Read each useful data set and label variables the Test data
* subject_test.txt was read into the table subjectsTest with one column and the variable name "Subjects"
* y_test.txt was read into the table testLabels with one column and the variable name "Activity"
* X_test.txt was read into the table testSet with 561 columns and the variable names from measurements (features.txt) were labeled to each variable

b. All the columns from the three tables subjectsTest, testLabels and testSet were merged into a fullTestSet that has 563 columns: Subject, Activity and the 561 measurements

####The exact same operations were performed on the Train data (a and b) in order to obtain the fullTrainSet.

####Both fullTrainSet and fullTestSet were merged into fullSet, that now has all rows from both sets.

###Selecting Columns
Within the names of features, we selected the ones including the strings "mean" and "std" (standard deviation).
We created a vector called columns with that selects Subject, Activity and the selected features, and that has a length of 88.
The fullSet was subset using this vector into meanStdSet that now has 88 columns.

###Renaming activities
Activites were named (initially lableled as number and a correspondance table was given through activity_labels.txt) using a for loop.
Each number was replaced by the activity name string.

###Clean names
All names of the measurement were explicited (full names) by replacing strings within the variables names.
Capital letters were used to begin labels, and the unuseful symbols were removed. Here are a few examples:
"TimeBodyAccelerometerMeanX"
"TimeBodyAccelerometerMeanY"                          
"TimeBodyAccelerometerMeanZ"
"TimeBodyAccelerometerStdX"                           
"TimeBodyAccelerometerStdY"
"TimeBodyAccelerometerStdZ"                           
"TimeGravityAccelerometerMeanX"
"TimeGravityAccelerometerMeanY"

The fullSet was simply renamed set after expliciting the columns names.

###Reducing data to averages
Subjects and activities were turned into factors, to order set and sort it.
Then, averages of each measurement variables (the renamed ones in the previous section: columns 3 to 88) are calculated per Subject and Activity and reagregated into a new table named tidySet.

##Output
The output is written in a text file, named tidySet.