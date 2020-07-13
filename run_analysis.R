library(tidyverse)

## load data
train_X <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/train/X_train.txt")
train_y <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/train/y_train.txt")
train_subject <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/train/subject_train.txt")
test_X <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/test/X_test.txt")
test_y <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/test/y_test.txt")
test_subject <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/test/subject_test.txt")

## combine test and training sets
combined_X <- rbind(train_X, test_X)
combined_y <- rbind(train_y, test_y)
combined_subject <- rbind(train_subject, test_subject)

## rename columns with meaningful variable names
features <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/features.txt")
variables <- features$V2
colnames(combined_X) <- variables

## select columns with mean and std information
idx <- which(str_detect(variables, regex("mean\\(\\)", ignore_case = TRUE)) | str_detect(variables, regex("std\\(\\)", ignore_case = TRUE)))
data <- combined_X[idx]

## create column with activity labels in main data.frame
activity_labels <- read.table("/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/UCI HAR Dataset/activity_labels.txt")
for (i in 1:length(combined_y$V1)) {
	data[i,"activity"] <- activity_labels$V2[as.numeric(combined_y$V1[i])]
}

## add subject to data.frame
colnames(combined_subject) <- "subject"
data <- cbind(data, combined_subject)

## independent tidy dataset
tmp <- group_by(data, activity, subject)
tidy <- summarise_all(tmp, mean)
write.table(tidy, file = "/Users/daniel/Desktop/JHU-Data-Science/Getting and Cleaning Data/getting_and_cleaning_data_assignment/tidy_data.txt", row.names = FALSE)
