# Download the data files from the given url:
download.file("https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip", 
                "data_zip", method = "curl")
# Unzip the files
unzip("data_zip")

# Load library:
library(dplyr)

# Read the needed dataframes:
act_labels <- read.table("UCI HAR Dataset/activity_labels.txt") %>%
                tbl_df()
features <- read.table("UCI HAR Dataset/features.txt") %>% 
                tbl_df()test_set <- read.table("UCI HAR Dataset/test/X_test.txt") %>% 
                tbl_df()
test_id <- read.table("UCI HAR Dataset/test/subject_test.txt") %>% 
                tbl_df()
test_activity <- read.table("UCI HAR Dataset/test/y_test.txt") %>% 
                tbl_df()
train_set <- read.table("UCI HAR Dataset/train/X_train.txt") %>% 
                tbl_df()
train_id <- read.table("UCI HAR Dataset/train/subject_train.txt") %>% 
                tbl_df()
train_activity <- read.table("UCI HAR Dataset/train/y_train.txt") %>% 
                tbl_df()

# Bind train and test data:
set <- rbind(train_set, test_set)
id <- rbind(train_id, test_id)
activity <- rbind(train_activity, test_activity)

# Change activity codes by activity names
activity <- inner_join(activity, act_labels)
activity <- select(activity, -V1)

# Set column names:
colnames(set) <- make.names(features$V2, unique = TRUE)
colnames(id) <- "Subject"
colnames(activity) <- "Activity"
        
# Select only mean and standard deviation from set data:
set_sel <- select(set, contains("mean"), contains("std"))

# Bind to obtain the tidy data:
tidy_df <- cbind(id, activity, set_sel) %>% tbl_df()

# Create tidy data set with the average of each variable 
# for each activity and each subject
average_df <- tidy_df %>%
        group_by(Subject, Activity) %>%
        summarize_all(mean)

# Save the tidy data:
write.table(average_df, file = "tidy_ave.txt", row.names = FALSE)
