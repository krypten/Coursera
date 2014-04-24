library(data.table)
library(reshape2)

dtSubTrain <- fread(file.path(getwd() , "UCI HAR Dataset/train/subject_train.txt"))

dtSubTest <- fread(file.path(getwd() , "UCI HAR Dataset/test/subject_test.txt"))

dtActTest <- fread(file.path(getwd(), "UCI HAR Dataset/test/y_test.txt"))
dtActTrain <- fread(file.path(getwd(), "UCI HAR Dataset/train/y_train.txt"))

tmp <- read.table(file.path(getwd() , "UCI HAR Dataset/test/X_test.txt"))
dtTest <- data.table(tmp)
tmp <- read.table(file.path(getwd() , "UCI HAR Dataset/train/X_train.txt"))
dtTrain <- data.table(tmp)


##Merge the training and the test sets

dtSubject <- rbind(dtSubTrain, dtSubTest)
dtActivity <- rbind(dtActTrain, dtActTest)
setnames(dtSubject, "V1", "subject")
setnames(dtActivity, "V1", "activity")

dt <- rbind(dtTrain, dtTest)
dtSubject <- cbind(dtSubject, dtActivity)
dt <- cbind(dtSubject, dt)
setkey(dt, subject, activity)


##Extract only the mean and standard deviation

dtFeature <- fread(file.path("UCI HAR Dataset/features.txt"))
setnames(dtFeature, names(dtFeature), c("num", "name"))

dtFeatures <- dtFeature[grepl("mean\\(\\)|std\\(\\)", name)]

dtFeatures$num <- dtFeatures[, paste0("V", num)]

dt <- dt[, c(key(dt), dtFeatures$num), with=FALSE]


##Use descriptive activity names

dtActLabel <- fread(file.path("UCI HAR Dataset/activity_labels.txt"))
setnames(dtActLabel, names(dtActLabel), c("activity", "name"))


##Label with descriptive activity names

dt <- merge(dt, dtActLabel, by="activity", all.x=TRUE)
setkey(dt, subject, activity, name)

dt <- data.table(melt(dt, key(dt), variable.name="num"))

dt <- merge(dt, dtFeatures[, list(num, name)], by="num", all.x=TRUE)

dt$activityN <- factor(dt$activity)
dt$feature <- factor(dt$name.y)

n <- 2
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepl("^t", dt$feature), grepl("^f", dt$feature)), ncol=nrow(y))
dt$featDomain <- factor(x %*% y, labels=c("Time", "Freq"))
x <- matrix(c(grepl("Acc", dt$feature), grepl("Gyro", dt$feature)), ncol=nrow(y))
dt$featInstrument <- factor(x %*% y, labels=c("Accelerometer", "Gyroscope"))
x <- matrix(c(grepl("BodyAcc", dt$feature), grepl("GravityAcc", dt$feature)), ncol=nrow(y))
dt$featAcceleration <- factor(x %*% y, labels=c(NA, "Body", "Gravity"))
x <- matrix(c(grepl("mean()", dt$feature), grepl("std()", dt$feature)), ncol=nrow(y))
dt$featVariable <- factor(x %*% y, labels=c("Mean", "SD"))

dt$featJerk <- factor(grepl("Jerk", dt$feature), labels=c(NA, "Jerk"))
dt$featMagnitude <- factor(grepl("Mag", dt$feature), labels=c(NA, "Magnitude"))

n <- 3
y <- matrix(seq(1, n), nrow=n)
x <- matrix(c(grepl("-X", dt$feature), grepl("-Y", dt$feature), grepl("-Z", dt$feature)), ncol=nrow(y))
dt$featAxis <- factor(x %*% y, labels=c(NA, "X", "Y", "Z"))


setkey(dt, subject, activity, featDomain, featAcceleration, featInstrument, featJerk, featMagnitude, featVariable, featAxis)
dtTidyData <- dt[, list(count = .N, average = mean(value)), by=key(dt)]

dtTidyData