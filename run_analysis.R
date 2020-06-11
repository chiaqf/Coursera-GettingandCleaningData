X_test<-read.table(".\\UCI HAR Dataset\\test\\X_test.txt")
y_test<-read.table(".\\UCI HAR Dataset\\test\\y_test.txt")
Subject_test <- read.table(".\\UCI HAR Dataset\\test\\subject_test.txt")

X_train<-read.table(".\\UCI HAR Dataset\\train\\X_train.txt")
y_train<-read.table(".\\UCI HAR Dataset\\train\\y_train.txt")
Subject_train <- read.table(".\\UCI HAR Dataset\\train\\subject_train.txt")

features<-read.table(".\\UCI HAR Dataset\\features.txt")

activity_labels <- read.table(".\\UCI HAR Dataset\\activity_labels.txt")

# 1. Merges the training and the test sets to create one data set.
X_total <- rbind(X_train, X_test)
y_total <- rbind(y_train, y_test)
Subject_total <- rbind(Subject_train, Subject_test)

# 2. Extracts only the measurements on the mean and standard deviation for each measurement.
selected_features <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),] #regex check with feature names
X_total <- X_total[,selected_features[,1]] #remove columns with feature id selected_features return [1 2 3 41 ....]

# 3. Uses descriptive activity names to name the activities in the data set
colnames(y_total) <- "activity" #add column names to y_total
y_total$activitylabel <- factor(y_total$activity, labels = as.character(activity_labels[,2]))
#^^ add another label using name
activitylabel <- y_total[,-1] # keep only activity label (string), remove activity (numbers)

# 4. Appropriately labels the data set with descriptive variable names.
colnames(X_total) <- features[selected_features[,1],2] #select features using chosen features index

# 5. From the data set in step 4, creates a second, independent tidy data set with the average
# of each variable for each activity and each subject.
colnames(Subject_total) <- "subject"
total <- cbind(X_total, activitylabel, Subject_total)
total_mean <- total %>% group_by(activitylabel, subject) %>% summarize_each(funs(mean))
write.table(total_mean, file = ".//UCI HAR Dataset//tidydata.txt", row.names = FALSE, col.names = TRUE)

#read it again to check
tidy_data<-read.table(".//UCI HAR Dataset//tidydata.txt")
