Course Project
===================

Steps :-
* load the files and folder from this github repository into your working directory
* the folder is : UCI HAR dataset and files are : run_analysis.R , tidydata.txt , CodeBook.md, README.md
* install 'reshape2' package (if not yet done)
* run the script - run_analysis.R (a tidy  data set - tidatdata.txt will be created/updated)

run_analysis.R Code explanation as per question bullets 1-5 :

1. Merges the training and the test sets to create one data set.
snippet : 
features1 <- read.table("./UCI HAR Dataset/features.txt")
features2 <- subset(features1,grepl("mean()",V2) | grepl("std()",V2))
features <- subset(features2,!grepl("meanFreq()",V2))
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")
merge_set <- rbind(test,train)

explanation: 
66 features having only mean() and std() features are extracted from 561 features.
Also merged the train and test datasets

2. Extracts only the measurements on the mean and standard deviation for each measurement. 
snippet:
indices <- features$V1
filter_set <- merge_set[indices]

explanation: 
get the index list for all 66 features.
'filter_set' gets the values of only these 66 features(mean and std) from the data of 561 features

3. Uses descriptive activity names to name the activities in the data set
snippet:
activity_test <- read.table("./UCI HAR Dataset/test/Y_test.txt")
activity_train <- read.table("./UCI HAR Dataset/train/y_train.txt")
activity_set <- rbind(activity_test,activity_train)
activity_set$V1 <- as.character(activity_set$V1)

activity_set$V1[activity_set$V1 == "1"] <- "WALKING"
activity_set$V1[activity_set$V1 == "2"] <- "WALKING_UPSTAIRS"
activity_set$V1[activity_set$V1 == "3"] <- "WALKING_DOWNSTAIRS"
activity_set$V1[activity_set$V1 == "4"] <- "SITTING"
activity_set$V1[activity_set$V1 == "5"] <- "STANDING"
activity_set$V1[activity_set$V1 == "6"] <- "LAYING"
colnames(activity_set) = "activity"

final_set <- cbind(filter_set,activity_set)

explanation: 
got all the activity code for test and train, merged it.
Then changed the corresponding activity code to activity name

4. Appropriately labels the data set with descriptive variable names.  
snippet:
c_names <- features$V2
c_names <- as.character(c_names)
c_names <- gsub("[\\(\\)\\-]","",c_names,)
colnames(filter_set) <- c_names

explanation: 
used gsub to make the variable names more clear , thus eliminated extra symbols like '-','(',')'
eg : changed tBodyAcc-mean()-X to tBodyAccmeanX 

5. From the data set in step 4, creates a second, independent tidy data set with the average of each 
variable for each activity and each subject.
snippet:
subsect_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subsect_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(subsect_test,subsect_train)
colnames(subjects) = "subject"
final_set <- cbind(final_set,subjects)

library(reshape2)
datamelt <- melt(final_set,id = c("activity","subject"), measure.vars = c_names)
tidydata <- dcast(datamelt, activity + subject ~ variable, mean)

write.table(tidydata,file="tidydata.txt",row.name=FALSE)

explanation: 
since we need data form subjects and activities, merge the subject data as column.
I used the dcast function to group the activities and subjects 
This acts as a group by , where we have 6 activities and 30 subject
So in order to get average for each activity and corresponding subject, there will be 6 X 30 = 180 combination
'activity + subject ~ variable' formula in dcast function does this job.
in the melt function - 'measure.vars = c_names' , c_names are the colnames we get from step 4.
c_names are the 66 features which is our variable names for final_set dataframe, other than activity and subject variables
so in the dcast function we take mean of values of all these 66 variables for each activity and subject   
final step is writing the output using write.table

