###

##Merges the training and the test sets to create one data set.

#This part is defining file path and names to be read

folder<-"~/R/UCI HAR Dataset/"

filenames_base<-c("y","X")

features<-read.table(paste0(folder,"features.txt"),stringsAsFactors =FALSE)
activity_labels<-read.table(paste0(folder,"activity_labels.txt"),stringsAsFactors =FALSE)

#initialisation of the table for test data
table_test<-read.table(paste0(folder,"test/subject_test.txt"))

#reading test data
for (name in filenames_base){
    file<-paste0(folder,"test/",name,"_test.txt")
    data_read<-read.table(file,strip.white = TRUE,stringsAsFactors =FALSE)
    table_test<-cbind(table_test,data_read)
}

#initialisation of the table for train data
table_train<-read.table(paste0(folder,"train/subject_train.txt"))

#reading train data
for (name in filenames_base){
    file<-paste0(folder,"train/",name,"_train.txt")
    data_read<-read.table(file,strip.white = TRUE,stringsAsFactors =FALSE)
    table_train<-cbind(table_train,data_read)
}

#merging train and test data into one table
table_all<-rbind(table_test,table_train)

variables_names<-c("Subject","Activity",features[,2])
colnames(table_all)<-variables_names

#table_all is now a merge of test and train data with the columns name filled with variable names

##Extracts only the measurements on the mean and standard deviation for each measurement.

#changing variable names
variables_names_mean_std<-colnames(table_mean_std)
variables_names_mean_std[303:344]<-paste0(303:344,variables_names_mean_std[303:344])
variables_names_mean_std[382:423]<-paste0(382:423,variables_names_mean_std[382:423])
variables_names_mean_std[461:502]<-paste0(461:502,variables_names_mean_std[461:502])
colnames(table_mean_std)<-variables_names_mean_std

# Extracting columns number with "mean()" or "std()" in the name
test_mean_or_std<-grep("mean[()]|std[()]",variables_names)
# adding the 1st and 2nd row
test_mean_or_std_plus<-c(1,2,test_mean_or_std)

# creating the table with only mean and std measurement
table_mean_std<-table_all[,test_mean_or_std_plus]

#Changing descriptive activity names to name the activities in the data set
table_mean_std$Activity<-as.character(table_mean_std$Activity)
table_mean_std$Activity[table_mean_std$Activity=="1"]<-"WALKING"
table_mean_std$Activity[table_mean_std$Activity=="2"]<-"WALKING_UPSTAIRS"
table_mean_std$Activity[table_mean_std$Activity=="3"]<-"WALKING_DOWNSTAIRS"
table_mean_std$Activity[table_mean_std$Activity=="4"]<-"SITTING"
table_mean_std$Activity[table_mean_std$Activity=="5"]<-"STANDING"
table_mean_std$Activity[table_mean_std$Activity=="6"]<-"LAYING"
table_mean_std$Activity<-as.factor(table_mean_std$Activity)
table_mean_std$Subject<-as.factor(table_mean_std$Subject)


#From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

#table averaged_table filling with averaged variables
averaged_table<-aggregate(table_mean_std[,3:table_size],list(Subject=table_mean_std$Subject,Activity=table_mean_std$Activity),FUN=mean)

#create files
write.table(table_mean_std,row.names=FALSE , file="table_mean_std.txt") 
write.table(averaged_table,row.names=FALSE, file="averaged_table.txt") 
