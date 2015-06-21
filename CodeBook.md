# Getting and Cleaning Data: Course Project Code Book

The input data was downloaded from: https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

A full description is available here: http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The requirements of the project solved by the run_analysis.R script are the following:

1. Merges the training ("./train/X_train.txt") and the test ("./test/X_test.txt") sets to create one data set with measurements. The new data frame has the dimensions of 10299x561. Also, two more sets are merged, "./train/subject_train.txt" and "./test/subject_test.txt", into a 10299x1 data frame of subject indexes. Finaly, the sets "./train/y_train.txt" and "./test/y_test.txt" are merged into a 10299x1 data frame with the activity indexes.

2. Extracts only the measurements on the mean and standard deviation for each measurement. There are 66 features in the original data measurements that are means or standard deviations, resulting in a new 10299x66 data frame. The name of the features are added from the file "features.txt" after removing the paranthesis and dashes. This last operation will be usefull in the step 4.

3. Uses descriptive activity names to name the activities in the data set. The activity labels are read from the file "activity_labels.txt" and applied to the activity indexes as: walking, walkingUpstairs, walkingDownstairs, sitting, standing, and laying.

4. Appropriately labels the data set with descriptive variable names. The subject and corresponding activity names are applied to the mean and std measurement data set, resulting in a new 10299x68 data frame. Feature names were created in the step 2 (see above).

5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject. The final tidy data set is saved as a text file "dataFinalAverages.txt", having 180 rows, 6 activities for each of the 30 subjects. The number of columns is 68, as in the data set created in the step 4, The first two features are the subject indexes and the activity names, respectively.   The rest of the 66 features are averages over each activity of every subject.
