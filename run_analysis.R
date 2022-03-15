#Downloading and unzipping dataset
#******************************************************************
#Setting up the project. 

if(!file.exists("./data")){dir.create("./data")}
#Here are the data for the project:
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./data/Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./data/Dataset.zip",exdir="./data")

#You should create one R script called run_analysis.R that does the following.

#******************************************************************
#Step 1.Merges the training and the test sets to create one data set.
#******************************************************************

# 1a. Reading trainings tables:

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# 1b. Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# 1c. Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# 1d. Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# 1.2 Assigning column names:

colnames(x_train) <- features[,2]
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

#1.3 Merging all data in one set:

mrg_train1 <- cbind(y_train, subject_train, x_train)
mrg_test1 <- cbind(y_test, subject_test, x_test)
masterdataframe <- rbind(mrg_train1, mrg_test1)

#dim(masterdataframe)
#[1] 10299   563

#Step 2.-Extracts only the measurements on the mean and standard deviation for each measurement.
#******************************************************************

#2a. Reading column names:

colNames <- colnames(masterdataframe)

#2b. Create vector for defining ID, mean and standard deviation:

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) )

#2c. Making nessesary subset from setAllInOne:

setForMeanAndStd <- masterdataframe[ , mean_and_std == TRUE]

#Step 3. Uses descriptive activity names to name the activities IN the data set
#******************************************************************

setForActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

#******************************************************************
#Step 4. Appropriately labels the data set with descriptive variable names.
#******************************************************************

#This has been completed in previous steps, see 1.3,2.2 and 2.3.

#******************************************************************
#Step 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.
#******************************************************************
secTidySet <- aggregate(. ~subjectId + activityId, setForActivityNames, mean)
secTidySet <- secTidySet[order(secTidySet$subjectId, secTidySet$activityId),]
