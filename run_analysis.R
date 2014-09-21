# load libraries
#library(reshape)
library(plyr)


# give them headings, and turn the numeric activities into something easier to read
xTrain = read.table("./data/train/X_train.txt")
yTrain = read.table("./data/train/y_train.txt")
subjectTrain = read.table("./data/train/subject_train.txt")

# test set
xTest = read.table("./data/test/X_test.txt")
yTest = read.table("./data/test/y_test.txt")
subjectTest = read.table("./data/test/subject_test.txt")
featuresdf = read.table("./data/features.txt")
headings = featuresdf$V2

# transfer headings to data set
colnames(xTrain) = headings
colnames(xTest) = headings

### format y dataset (yTest and yTrain)
# change V1 variable to something descriptive "activity"
yTest <- rename(yTest, c(V1="activity"))
yTrain <- rename(yTrain, c(V1="activity"))

# change data values in yTest according to activity_labels.txt file
# there are 6 activities
activitydf  = read.table("./data/activity_labels.txt")

# convert variable names to lowercase
activityLabels = tolower(levels(activitydf$V2))

# convert $activity to factor and add descriptive labels
yTrain$activity = factor(
  yTrain$activity, 
  labels = activityLabels
)

yTest$activity = factor(
  yTest$activity, 
  labels = activityLabels
)


### Format subject variables (subject_train subject_test)
# change subject variable name to be descriptive
subjectTrain <- rename(subjectTrain, c(V1="subjectid"))
subjectTest <- rename(subjectTest, c(V1="subjectid"))


### Merge the training and the test sets to create one data set.

# combine (x,y,subject) for the training and test sets
train = cbind(subjectTrain,yTrain,xTrain)
test = cbind(subjectTest, yTest,xTest )

# combine train and test set  
fullData = rbind(train, test)

pattern = "mean|std|subjectid|activity"
tidyData = fullData[,grep(pattern , names(fullData), value=TRUE)]



# summarize data
result = ddply(tidyData, .(subjectid,activity ), numcolwise(mean))

# write file to output
write.table(result, file="data.txt", sep = "\t", append=F)