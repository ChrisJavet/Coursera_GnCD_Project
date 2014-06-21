## Getting & CLeaning Data
## Project
library(reshape2)

## Collect Activity Labels & Features
activity_labels <- read.table("UCI HAR Dataset/activity_labels.txt", 
                              col.names = c("Activity.number", "Activity.name"))
features <- read.table("UCI HAR Dataset/features.txt",
                       col.names = c("Feature.number", "Feature.name"))

## Select features based on the string 'mean()' and 'std()' being contained in the feature name
features$selected <- grepl("mean\\(\\)", features$Feature.name) | grepl("std\\(\\)", features$Feature.name)
features_columns <- features[(features$selected), "Feature.number"]
# Remove the '-' and the '()' from the feature names
features$Feature.name <- gsub("[[:punct:]]", "", features$Feature.name)
# define a vector containing the feature names of the selected features
features_columns_names <- features[(features$selected), "Feature.name"]

##### OBJECTIVE # 1 & # 4
## Merges the training and the test sets to create one data set.
## Appropriately labels the data set with descriptive variable names. 

# Read Test datasets
test_dataset <- read.table("UCI HAR Dataset/test/X_test.txt", col.names = features$Feature.name)
test_subject_dataset <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = "Subject")
test_activity_dataset <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = "Activity.number")

# Read Training datasets
training_dataset <- read.table("UCI HAR Dataset/train/X_train.txt", col.names = features$Feature.name)
training_subject_dataset <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = "Subject")
training_activity_dataset <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = "Activity.number")

# Merge datasets, first the test and then the training datasets
merged_dataset <- rbind(test_dataset, training_dataset)
subject_dataset <- rbind(test_subject_dataset, training_subject_dataset)
activity_dataset <- rbind(test_activity_dataset, training_activity_dataset)

##### OBJECTIVE # 2
## Extracts only the measurements on the mean and standard deviation for each measurement. 
merged_dataset_extract <- cbind(merged_dataset[, features_columns], subject_dataset, activity_dataset)

##### OBJECTIVE # 3
## Uses descriptive activity names to name the activities in the data set
merged_dataset_and_activityname_extract <- merge(merged_dataset_extract, activity_labels)

## OBJECTIVE # 5
## Creates a second, independent tidy data set with the average of each variable for each activity and each subject
temporary_dataset <- melt(data = merged_dataset_and_activityname_extract, 
                          id = c("Subject", "Activity.name"), 
                          measure.vars = features_columns_names)
tidy_dataset <- dcast(temporary_dataset, Subject + Activity.name ~ variable, mean)
