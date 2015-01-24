features1 <- read.table("./UCI HAR Dataset/features.txt")
features2 <- subset(features1,grepl("mean()",V2) | grepl("std()",V2))
features <- subset(features2,!grepl("meanFreq()",V2))
test <- read.table("./UCI HAR Dataset/test/X_test.txt")
train <- read.table("./UCI HAR Dataset/train/X_train.txt")

merge_set <- rbind(test,train)
indices <- features$V1
filter_set <- merge_set[indices]

c_names <- features$V2
c_names <- as.character(c_names)
c_names <- gsub("[\\(\\)\\-]","",c_names,)
colnames(filter_set) <- c_names

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

subsect_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
subsect_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
subjects <- rbind(subsect_test,subsect_train)
colnames(subjects) = "subject"
final_set <- cbind(final_set,subjects)

library(reshape2)
datamelt <- melt(final_set,id = c("activity","subject"), measure.vars = c_names)
tidydata <- dcast(datamelt, activity + subject ~ variable, mean)

write.table(tidydata,file="tidydata.txt",row.name=FALSE)
