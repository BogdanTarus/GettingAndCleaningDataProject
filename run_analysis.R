# This R script responds to the questions within the Project assignement of the "Getting and Cleaning Data" Coursera course
# The input data of the project were downloaded from
## "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
## and unziped in the working directory

# This R script solves the following five tasks:

###
# 1. Merges the training and the test sets to create one data set.

## 1.1. merge the two sets with variable data:
dataTrain <- read.table("./train/X_train.txt")
dataTest  <- read.table("./test/X_test.txt")
dataTotal <- rbind(dataTrain, dataTest)

## 1.2. merge the two sets with subject indexes:
subjectTrain <- read.table("./train/subject_train.txt")
subjectTest  <- read.table("./test/subject_test.txt")
subjectTotal <- rbind(subjectTrain, subjectTest)

## 1.3. merge the two sets with activity indexes:
activityTrain <- read.table("./train/y_train.txt")
activityTest  <- read.table("./test/y_test.txt")
activityTotal <- rbind(activityTrain, activityTest)

###
# 2. Extracts only the measurements on the mean and standard deviation for each measurement.

# According to the feature_info.txt file, the names of the features
# that are measurements on the mean and standard deviation should contain
# "mean()" and "std()", respectively.

featureNames <- read.table("features.txt")
featureMeanStdIndex <- grep("mean\\(\\)|std\\(\\)", featureNames[, 2]) # extract the feature indexes that measure the mean
                                                                       # OR
                                                                       # the standard deviation

dataMeanStd <- dataTotal[, featureMeanStdIndex] # mead and std measurments extraction

# add the feature names as column data.frame names to "dataMeanStd" (after a bit of cleaning and shortening)
featureMeanStdNames <- featureNames[featureMeanStdIndex, 2]
featureMeanStdNames <- gsub("\\(|\\)|-", "", featureMeanStdNames)
featureMeanStdNames <- gsub("mean", "Mean", featureMeanStdNames)
featureMeanStdNames <- gsub("std", "Std", featureMeanStdNames)
names(dataMeanStd)  <- featureMeanStdNames

###
# 3. Uses descriptive activity names to name the activities in the data set

# make the activity labels more friendly
activityLabels <- read.table("activity_labels.txt")
activityLabels[, 2] <- gsub("_", " ", activityLabels[, 2])
activityLabels[, 2] <- tolower(activityLabels[, 2])
activityLabels[, 2] <- gsub("upstairs", "Upstairs", activityLabels[, 2])
activityLabels[, 2] <- gsub("downstairs", "Downstairs", activityLabels[, 2])
activityLabels[, 2] <- gsub(" ", "", activityLabels[, 2])

activityTotalLabeled        <- activityTotal # keep the original activity data set and create a new set to be modified
names(activityTotalLabeled) <- "activity"
activityTotalLabeled[, 1]   <- activityLabels[activityTotal[, 1], 2] # change the index to the appropriate activity label

###
# 4. Appropriately labels the data set with descriptive variable names.

names(subjectTotal) <- "subject"

# concatenate the subject ("subjectTotal") and corresponding activity names ("activityTotalLabeled") to
# the mean and std measurement data ("dataMeanStd")

dataABC <- cbind(subjectTotal, activityTotalLabeled, dataMeanStd)

###
# 5. From the data set in step 4 ("dataABC"),
#    creates a second, independent tidy data set with the average of each variable for each activity and each subject.

discreteSubjects <- unique(subjectTotal$subject) # get the individual subjects
numberSubjects   <- length(discreteSubjects)     # get the number of subjects
numberActivities <- dim(activityLabels)[1]       # get the number of activities performed by the subjects
numberColumnsFin <- dim(dataABC)[2]              # get the number of columns in the final data set to be
                                                 ## created (the same as in "dataABC")

# initialize an "empty" data.frame with numberSubjects * numberActivities rows and numberColumnsFin columns
dataFinal <- data.frame(matrix(NA, nrow=numberSubjects*numberActivities, ncol=numberColumnsFin))
names(dataFinal) <- names(dataABC)

# In "dataFinal", calculate the averages of each column, excepting the first two, using a double loop
line = 1
for (subj in 1:numberSubjects) {
    for (actv in 1:numberActivities) {
        dataFinal[line, 1] = discreteSubjects[subj]
        dataFinal[line, 2] = activityLabels[actv, 2]

        arange <- dataABC[dataABC$subject==subj & dataABC$activity==activityLabels[actv, 2], ]
        dataFinal[line, 3:numberColumnsFin] <- colMeans(arange[, 3:numberColumnsFin])
        line = line+1
    }
}

write.table(dataFinal, "dataFinalAverages.txt", row.name=FALSE)
