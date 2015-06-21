## Location of data
Dataloc <- file.path("./data" , "UCI HAR Dataset")

##Read data for later use
dataActivityTest  <- read.table(file.path( Dataloc, "test" , "Y_test.txt" ),header = FALSE)
dataActivityTrain <- read.table(file.path( Dataloc, "train", "Y_train.txt"),header = FALSE)
dataSubjectTrain  <- read.table(file.path( Dataloc, "train", "subject_train.txt"),header = FALSE)
dataSubjectTest   <- read.table(file.path( Dataloc, "test" , "subject_test.txt"),header = FALSE)
dataFeaturesTest  <- read.table(file.path( Dataloc, "test" , "X_test.txt" ),header = FALSE)
dataFeaturesTrain <- read.table(file.path( Dataloc, "train", "X_train.txt"),header = FALSE)

##combine by rows 
dataSubject <- rbind(dataSubjectTrain, dataSubjectTest)
dataActivity<- rbind(dataActivityTrain, dataActivityTest)
dataFeatures<- rbind(dataFeaturesTrain, dataFeaturesTest)

##Variables
names(dataSubject)<-c("subject")
names(dataActivity)<- c("activity")
dataFeaturesNames <- read.table(file.path(Dataloc, "features.txt"),head=FALSE)
names(dataFeatures)<- dataFeaturesNames$V2

##Merge columns
dataCombine <- cbind(dataSubject, dataActivity)
Data <- cbind(dataFeatures, dataCombine)

##Subset on the mean and standard deviation
subdataFeaturesNames<-dataFeaturesNames$V2[grep("mean\\(\\)|std\\(\\)", dataFeaturesNames$V2)]

##Subset the data frame by names of Features
selectedNames<-c(as.character(subdataFeaturesNames), "subject", "activity" )
Data<-subset(Data,select=selectedNames)

##Read activity names
activityLabels <- read.table(file.path(Dataloc, "activity_labels.txt"),header = FALSE)

##Variables
names(Data)<-gsub("^t", "time", names(Data))
names(Data)<-gsub("^f", "frequency", names(Data))
names(Data)<-gsub("Acc", "Accelerometer", names(Data))
names(Data)<-gsub("Gyro", "Gyroscope", names(Data))
names(Data)<-gsub("Mag", "Magnitude", names(Data))
names(Data)<-gsub("BodyBody", "Body", names(Data))

## Produce output
library(plyr);
OutputData<-aggregate(. ~subject + activity, Data, mean)
OutputData<-OutputData[order(OutputData$subject,OutputData$activity),]
write.table(OutputData, file = "tidydata.txt",row.name=FALSE)


