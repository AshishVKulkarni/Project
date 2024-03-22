
```{r}
#storing the source data url
datafile_url <- "https://intro-datascience.s3.us-east-2.amazonaws.com/HMO_data.csv"
#using read.csv() to create dataframe
HMO_data = read.csv(url(datafile_url))
#top 6 rows for data overview
head(HMO_data)
```
```{r}
#metadata
str(HMO_data)
```

```{r}
# Making a copy of data
# We will be exploring and cleaning the copy of data
#converting categorical data into factor levels

df_HMO_data <- HMO_data
df_HMO_data$smoker <- as.factor(df_HMO_data$smoker)
df_HMO_data$location <- as.factor(df_HMO_data$location)
df_HMO_data$location_type <- as.factor(df_HMO_data$location_type)
df_HMO_data$education_level <- as.factor(df_HMO_data$education_level)
df_HMO_data$yearly_physical <- as.factor(df_HMO_data$yearly_physical)
df_HMO_data$exercise <- as.factor(df_HMO_data$exercise)
df_HMO_data$married <- as.factor(df_HMO_data$married)
df_HMO_data$gender <- as.factor(df_HMO_data$gender)

#metadata
str(df_HMO_data)
```

```{r}
#statistical information of the dataframe
summary(df_HMO_data)
```

```{r}
# making a fuction to do the analysis 
hist_plot <- function (sample, breaks = 30) {
  # Code
  # 2.5% Threshold
  # the value for 2.5 % Threshold
  min_quantile <- quantile(sample, 0.025, na.rm = TRUE)
  # 97.5% Threshold
  # the value for 97.5 % Threshold
  max_quantile <- quantile(sample, 0.975, na.rm = TRUE)

  # Sample mean
  sample_mean <- mean(sample, na.rm = TRUE)
  sample_median <- median(sample, na.rm = TRUE)

  # Displaying histogram
  hist(sample, breaks = breaks)
  abline(v=sample_mean, lwd=3, col= 'blue') # Population mean line 
  abline(v=sample_median, lwd=3) # Population Median line 
  abline(v=min_quantile, lwd=3, lty='dashed') # 2.5% line 
  abline(v=max_quantile, lwd=3, lty='dashed') # 97.5% line 
  print(paste('Mean:', sample_mean ))
}

hist_plot(df_HMO_data$cost)
```


```{r}
# Checking for NAs

check_NA <- function(df){
  for (col in colnames(df)){
    print(paste(col,':', nrow(df[is.na(df[col]),])))
    # print(df[is.na(df[col]),])
  }
}

check_NA(df_HMO_data)

# df[is.na(df$LAPOP1_10),]
```

```{r}
#count of total NA values
nrow(df_HMO_data[((is.na(df_HMO_data$bmi)) | (is.na(df_HMO_data$hypertension))),])
# Checking BMI Distribution across location
df_HMO_data %>% filter(!is.na(bmi)) %>% group_by(location) %>% summarise(bmi =mean(bmi))
# Checking BMI Distribution across smokers
df_HMO_data %>% filter(!is.na(bmi)) %>% group_by(smoker) %>% summarise(bmi =mean(bmi))
# Checking BMI Distribution across smokers
df_HMO_data %>% filter(!is.na(bmi)) %>% group_by(smoker) %>% summarise(bmi =mean(bmi))
# BMI Imputation
df_HMO_data$bmi <- na_interpolation(df_HMO_data$bmi)
# df_HMO_data$hypertension <- na_interpolation(df_HMO_data$hypertension)

# Null hypertension set to 0
df_HMO_data["hypertension"][is.na(df_HMO_data["hypertension"])] <- 0
#data overview of 10 rows
head(df_HMO_data,10)
```

```{r}
# Threshold
val_threshold <- median(df_HMO_data$cost)

cost_cat <- function(x){
  r <- case_when((is.na(x)) ~'NA'
    , (val_threshold < x) ~ 'Expensive'
    , (val_threshold >= x) ~ 'Inexpensive')
  return(r)
}
```

```{r}
age_cat <- function(x){
  r <- case_when((is.na(x)) ~'NA'
    , x < 13 ~ 'Child'
    , (x >= 13 & x < 20) ~ 'Teen'
    , (x >= 20 & x < 30) ~ 'Young Adult'
    , (x >= 30 & x < 50) ~ 'Adult'
    , (x >= 50 & x < 70) ~ 'Older Adult'
    , (x >= 70) ~ 'Senior citizen')
  return(r)
}
```

```{r}
bmi_cat <- function(x){
  r <- case_when((is.na(x)) ~'NA'
    , x < 18.5 ~ 'Underweight'
    , (x >= 18.5 & x < 25.0) ~ 'Healthy'
    , (x >= 25.0 & x < 30.0) ~ 'Overweight'
    , (x >= 30.0) ~ 'Obese')
  return(r)
}
```

```{r}
#statistical information
summary(df_HMO_data$children)
child_cat <- function(x){
  r <- case_when((is.na(x)) ~ 'NA'
    , (x == 0) ~ 'no children'
    , (x > 0 & x <=2) ~ '2 or less'
    , (x > 2) ~ 'more than 2')
  return(r)
}
```

```{r}
# Cost Category
df_HMO_data <- df_HMO_data %>% mutate(cost_category = as.factor(cost_cat(cost)))

# Age Category
df_HMO_data <- df_HMO_data %>% mutate(age_category = as.factor(age_cat(age)))

# BMI Category
df_HMO_data <- df_HMO_data %>% mutate(bmi_category = as.factor(bmi_cat(bmi)))

# Child Category
df_HMO_data <- df_HMO_data %>% mutate(child_category = as.factor(child_cat(children)))
```

```{r}
# Function to label class
class_label_gen <- function(data, num_bins){
  num_bins = num_bins-1
  # calculate the bin width
  bin_width <- ceiling((max(data) - min(data)) / num_bins)

  # create the bin labels
  bin_labels <- paste0(min(data) + (0:num_bins) * bin_width, "-", min(data) + (1:num_bins) * bin_width - 1)
  # bin_labels <- min(data) + (0:num_bins) * bin_width

  return(bin_labels)
}
```

```{r}
# Cost Class range
#creating new column segregating cost in classes
break_n = 10
df_HMO_data$cost_class <- cut(df_HMO_data$cost, breaks = break_n, labels = class_label_gen(df_HMO_data$cost,break_n))
#overview of top 6 rows
head(df_HMO_data)
#metadata
str(df_HMO_data)
```

```{r}
# Calculting deciles
# deciling patients based on cost
df_HMO_data$cost_decile <- as.factor(ntile(-df_HMO_data$cost, 10))#, weights = df_HMO_data$cost))
#overview of top 6 rows
head(df_HMO_data)
# Decile stats
df_top_spenders <- df_HMO_data %>%  group_by(cost_decile) %>% 
  summarise(count = n_distinct(X), avg_cost =mean(cost), sum_cost = sum(cost)) %>% 
    summarise(cost_decile, count, avg_cost, sum_cost
    , cum_sum_cost = cumsum(sum_cost)
    , patient_perc = round(100*cumsum(count)/sum(count),2)
    , cost_perc = round(100*cumsum(sum_cost)/sum(sum_cost),2))

df_top_spenders
```

```{r}

# Create the plot
my_plot <- ggplot(df_top_spenders, aes(x = patient_perc))


# Add the second y-axis (left)
my_plot <- my_plot + geom_bar(aes(y = avg_cost), stat = "identity", fill = "dodgerblue")


# Add the first y-axis (right)
my_plot <- my_plot + geom_line(aes(y = cost_perc*160), color = "green4")

my_plot <- my_plot + scale_y_continuous(
  name = "Average Cost",
  sec.axis = sec_axis(~ ./160, name = "Percentage of total cost")
)

# Add labels and titles
my_plot <- my_plot + labs(x = "Percentage of patients in order of cost", y = "Percentage of total cost and Average Cost")
my_plot <- my_plot + ggtitle("Dual Axis Chart")

# Customize the theme
my_plot <- my_plot + theme_bw() + theme(
  plot.title = element_text(size = 14, face = "bold"),
  axis.title.x = element_text(size = 12),
  axis.title.y = element_text(size = 12),
  axis.text = element_text(size = 10),
  panel.grid.major = element_blank(),
  panel.grid.minor = element_blank(),
  legend.position = "none"
)

# Display the plot
my_plot

#data overview 
head(df_HMO_data)
#statistical information for top 2 cost_deciles
summary(df_HMO_data[which(df_HMO_data$cost_decile %in% c('1', '2')),])
```

```{r}
# Histogram of cost distibution
hist(df_HMO_data$cost, breaks = 100)#, xlim = c(0,10000))
#abline for mean
abline(v=mean(df_HMO_data$cost), col='red', lwd=3, lty='dashed')
#abline for median
abline(v=median(df_HMO_data$cost), col='blue', lwd=3, lty='dashed')
#abline showing 80th percentile
abline(v=quantile(df_HMO_data$cost, c(.8)), col='Green', lwd=3, lty='dashed')
```

```{r}
n = 200

#create visualization of the distribution of costs across different categories,
df_HMO_data$cost_categories <- cut(df_HMO_data$cost, breaks = n, labels = class_label_gen(df_HMO_data$cost,n))

freq_table <- df_HMO_data %>% group_by(cost_categories) %>% summarise(cost = sum(cost))

# create a bar chart of the frequency table
ggplot(freq_table, aes(x = cost_categories, y = cost)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "My Bar Chart", x = "Group", y = "Total")
```

```{r}
#cost distrubution for maximum cost 
freq_table[which.max(freq_table$cost),]
```

```{r}
# BMI

data = df_HMO_data$bmi
hist(data, breaks = 100)
abline(v=mean(data), col='red', lwd=3, lty='dashed')

```

```{r}
# Children

data = df_HMO_data$children
hist(data, breaks = 6)
abline(v=mean(data), col='red', lwd=3, lty='dashed')
```


```{r}
# Age

data = df_HMO_data$age
hist(data, breaks = 6)
abline(v=mean(data), col='red', lwd=3, lty='dashed')
```

```{r}
#metadata
str(df_HMO_data)
```

```{r}
# BMI
ggplot(data=df_HMO_data) + aes(x=bmi, y=cost) + geom_point() +
 geom_smooth(method="lm", se=FALSE)
#line fitting the linear equation
```

```{r}
# AGE
ggplot(data=df_HMO_data) + aes(x=children, y=cost) + geom_point() +
 geom_smooth(method="lm", se=FALSE)
#line fitting the linear equation
```


```{r}
# hypertension
ggplot(data=df_HMO_data) + aes(x=hypertension, y=cost) + geom_point() +
 geom_smooth(method="lm", se=FALSE)
#line fitting the linear equation
```


```{r}
# Children
ggplot(data=df_HMO_data) + aes(x=age, y=cost) + geom_point() +
 geom_smooth(method="lm", se=FALSE)
#line fitting the linear equation
```


```{r}
#map plot for location and average cost data
GroupedData <- df_HMO_data%>%group_by(location)%>%summarise(Avg_cost =mean(cost))
state <- map_data("state")
# colnames(GroupedData)[6]<- "region"
GroupedData$region <- GroupedData$location
GroupedData$region <- tolower(GroupedData$region)
MergedData <- merge(state,GroupedData, on="region")
MergedData <- MergedData%>%arrange(order)
#To create a filled map
MyMap <- ggplot(MergedData)+coord_map()+geom_polygon(aes(x=long,y=lat,group=group, fill=Avg_cost), color="red")
MyMap
```


```{r}
#map plot for location and total cost data
GroupedData <- df_HMO_data%>%group_by(location)%>%summarise(sum_cost =sum(cost))
state <- map_data("state")
# colnames(GroupedData)[6]<- "region"
GroupedData$region <- GroupedData$location
GroupedData$region <- tolower(GroupedData$region)
MergedData <- merge(state,GroupedData, on="region")
MergedData <- MergedData%>%arrange(order)
#To create a filled map
MyMap <- ggplot(MergedData)+coord_map()+geom_polygon(aes(x=long,y=lat,group=group, fill=sum_cost), color="red")
MyMap
```


```{r}
#Location and average cost
GroupedData <- df_HMO_data%>%group_by(location)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData, aes(x=location, y=Avg_cost)) + geom_bar(stat="identity")

#metadata
str(df_HMO_data)
```


```{r}
#smoker and average cost
GroupedData1 <- df_HMO_data%>%group_by(smoker)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData1, aes(x=smoker, y=Avg_cost)) + geom_bar(stat="identity")

```

```{r}
#Marital Status and Average Cost
GroupedData2 <- df_HMO_data%>%group_by(married)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData2, aes(x=married, y=Avg_cost)) + geom_bar(stat="identity")


```


```{r}
#Exercise and Average Cost
GroupedData3 <- df_HMO_data%>%group_by(exercise)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData3, aes(x=exercise, y=Avg_cost)) + geom_bar(stat="identity")


```


```{r}
#Gender and Average Cost
GroupedData4 <- df_HMO_data%>%group_by(gender)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData4, aes(x=gender, y=Avg_cost)) + geom_bar(stat="identity")

```


```{r}
# yearly_physical and average cost

GroupedData4 <- df_HMO_data%>%group_by(yearly_physical)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData4, aes(x=yearly_physical, y=Avg_cost)) + geom_bar(stat="identity")


```


```{r}
# location_type

GroupedData4 <- df_HMO_data%>%group_by(location_type)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData4, aes(x=location_type, y=Avg_cost)) + geom_bar(stat="identity")


```


```{r}
# education_level and average cost
GroupedData5 <- df_HMO_data%>%group_by(education_level)%>%summarise(Avg_cost =mean(cost))

ggplot(data=GroupedData5, aes(x=education_level, y=Avg_cost)) + geom_bar(stat="identity")



```

```{r}
#predictor is bmi
lm_out <- lm(cost ~ bmi, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
#predictor is age
lm_out <- lm(cost ~ age, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
#predictor is bmi and age
lm_out <- lm(cost ~ age + bmi, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
library(tidyverse)
HistPlotCost1 <- ggplot(df_HMO_data, aes(x=cost)) + geom_histogram(bins = 20,color="black", fill="white")
HistPlotCost1 <- HistPlotCost1 + ggtitle("Cost Histogram")
HistPlotCost1
```


```{r}
#removing skewness by increasing bins
library(tidyverse)
HistPlotCost2 <- ggplot(df_HMO_data, aes(x=cost)) + geom_histogram(bins = 50,color="black", fill="white") + xlim(0,2000)
HistPlotCost2 <- HistPlotCost2 + ggtitle("Cost Histogram")
HistPlotCost2
```


```{r}
lm_all <- lm(cost ~age+bmi+children+smoker+location+location_type+education_level+yearly_physical+exercise+married+hypertension+gender, data = df_HMO_data)
print(lm_all)
summary(lm_all)
```


```{r}
lm_out <- lm(cost ~ smoker, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```

```{r}
lm_out <- lm(cost ~ exercise, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ hypertension, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ children, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ age + bmi + smoker, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ age + bmi+ exercise, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ smoker+ bmi+exercise+hypertension, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ exercise+hypertension, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ age + smoker, data = df_HMO_data)
print(lm_out)
summary(lm_out)
str(df_HMO_data)
```
```{r}
```


```{r}
# BEST MODEL
lm_out <- lm(cost ~ age + bmi + smoker + hypertension + children + exercise, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
lm_out <- lm(cost ~ age + bmi + smoker + children + exercise, data = df_HMO_data)
print(lm_out)
summary(lm_out)
```


```{r}
library(rio)
library(caret)
library(kernlab)
library(e1071)
df_HMO_sub <- df_HMO_data
cols <- c("age", "bmi", "children","cost", "smoker", "exercise", "hypertension" )
df_HMO_sub<-df_HMO_sub[,cols]
head(df_HMO_sub)

set.seed(111)
subHMO<- df_HMO_sub
trainList <- createDataPartition(y=subHMO$cost,p=0.70,list=FALSE)
trainSet <- subHMO[trainList,]
testSet <- subHMO[-trainList,]
```


```{r}
fit1 <- train(cost~.,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit1
str(df_HMO_data)
```


```{r}
df_HMO_sub <- df_HMO_data
cols <- c("age", "bmi", "children","cost_class", "smoker", "exercise", "hypertension" )
df_HMO_sub<-df_HMO_sub[,cols]
# head(df_HMO_sub)

set.seed(111)
subHMO<- df_HMO_sub
trainList <- createDataPartition(y=subHMO$cost_class,p=0.70,list=FALSE)
trainSet <- subHMO[trainList,]
df_HMO_sub$cost_class <- as.factor(df_HMO_sub$cost_class)
testSet <- subHMO[-trainList,]
testSet <- testSet[-which(testSet$cost_class == '49530-55720'),]
head(testSet)
summary(testSet)
```


```{r}
fit1 <- train(cost_class~.,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit1
```


```{r}
df_HMO_sub <- df_HMO_data
cols <- c("age", "bmi", "children","cost_category", "smoker", "exercise", "hypertension" )
df_HMO_sub<-df_HMO_sub[,cols]
df_HMO_sub$cost_category <- as.factor(df_HMO_sub$cost_category)
head(df_HMO_sub)

```


```{r}
library(rio)
library(caret)
library(kernlab)

set.seed(111)
subHMO<- df_HMO_sub
trainList <- createDataPartition(y=subHMO$cost_category,p=0.70,list=FALSE)
trainSet <- subHMO[trainList,]
testSet <- subHMO[-trainList,]
dim(trainSet)
dim(testSet)
fit1 <- train(cost_category~.,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit1
```


```{r}
library(caret)
library(kernlab)

fit1 <- train(cost_category~.,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit1
summary(fit1)
```

```{r}
# library(caret)
# library(kernlab)

svmPred <-predict(fit1,testSet)
confusion1 <- table(svmPred, testSet$cost_category)
confusion1
prop.table(confusion1)
confusion2 <- confusionMatrix(svmPred, testSet$cost_category)
confusion2
```


```{r}
# library(caret)
# library(kernlab)

fit <- train(cost_category~age+bmi+smoker,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit
svmPred <-predict(fit,testSet)
confusion1 <- table(svmPred, testSet$cost_category)
confusion1
prop.table(confusion1)
confusion2 <- confusionMatrix(svmPred, testSet$cost_category)
confusion2
```

```{r}
library(caret)
library(kernlab)
fit <- train(cost_category~age+bmi+exercise,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit
svmPred <-predict(fit,testSet)
confusion1 <- table(svmPred, testSet$cost_category)
confusion1
prop.table(confusion1)
confusion2 <- confusionMatrix(svmPred, testSet$cost_category)
confusion2
```


```{r}
library(caret)
library(kernlab)
fit <- train(cost_category~bmi+smoker+(exercise=="Not-Active")+hypertension,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit
svmPred <-predict(fit,testSet)
confusion1 <- table(svmPred, testSet$cost_category)
confusion1
prop.table(confusion1)
confusion2 <- confusionMatrix(svmPred, testSet$cost_category)
confusion2
```


```{r}
library(caret)
library(kernlab)
fit <- train(cost_category~bmi+smoker+exercise+hypertension,data = trainSet, method="svmRadial",preProc=c("center","scale"))
fit
svmPred <-predict(fit,testSet)
confusion1 <- table(svmPred, testSet$cost_category)
confusion1
prop.table(confusion1)
confusion2 <- confusionMatrix(svmPred, testSet$cost_category)
confusion2
```


```{r}
library(caret)
library(kernlab)
modksvm	<- ksvm(cost_category~.,data=trainSet, C=5,cross=3,prob.model=TRUE)
modksvm
predout <-predict(modksvm,testSet)
confusion1 <- table(predout, testSet$cost_category)
prop.table(confusion1)
confusion2 <- confusionMatrix(predout, testSet$cost_category)
confusion2
```


```{r}
library(caret)
library(kernlab)
modksvm	<- ksvm(cost_category~bmi+smoker+exercise,data=trainSet, C=5,cross=3,prob.model=TRUE)
modksvm
predout <-predict(modksvm,testSet)
confusion1 <- table(predout, testSet$cost_category)
prop.table(confusion1)
confusion2 <- confusionMatrix(predout, testSet$cost_category)
confusion2
```


```{r}
library(caret)
library(kernlab)
modksvm	<- ksvm(cost_category~bmi+smoker+hypertension,data=trainSet, C=5,cross=3,prob.model=TRUE)
modksvm
predout <-predict(modksvm,testSet)
confusion1 <- table(predout, testSet$cost_category)
prop.table(confusion1)
confusion2 <- confusionMatrix(predout, testSet$cost_category)
confusion2
```
```{r}
library(caret)
library(kernlab)
modksvm	<- ksvm(cost_category~bmi+exercise+hypertension,data=trainSet, C=5,cross=3,prob.model=TRUE)
modksvm
predout <-predict(modksvm,testSet)
confusion1 <- table(predout, testSet$cost_category)
prop.table(confusion1)
confusion2 <- confusionMatrix(predout, testSet$cost_category)
confusion2
```


```{r}
library(caret)
library(kernlab)
modksvm	<- ksvm(cost_category~age+exercise+hypertension,data=trainSet, C=5,cross=3,prob.model=TRUE)
modksvm
predout <-predict(modksvm,testSet)
confusion1 <- table(predout, testSet$cost_category)
prop.table(confusion1)
confusion2 <- confusionMatrix(predout, testSet$cost_category)
confusion2
```


```{r}
library(caret)
library(kernlab)
modksvm	<- ksvm(cost_category~bmi+smoker+exercise+hypertension,data=trainSet, C=5,cross=3,prob.model=TRUE)
modksvm
predout <-predict(modksvm,testSet)
confusion1 <- table(predout, testSet$cost_category)
prop.table(confusion1)
confusion2 <- confusionMatrix(predout, testSet$cost_category)
confusion2
```


```{r}
hypertension_cat <- function(x){
  r <- case_when((is.na(x)) ~'NA'
    , (x == 0) ~ 'no'
    , (x == 1) ~ 'yes')
  return(r)
}
df_HMO_data <- df_HMO_data %>% mutate(hypertension_category = hypertension_cat(hypertension))
head(df_HMO_data)
```


```{r}
df_HMO_one <- df_HMO_data
cols <- c("age_category", "bmi_category", "child_category","cost_category", "smoker","location", 
"location_type", "education_level", "yearly_physical", "exercise", "married","hypertension_category","gender" )
df_HMO_one<-df_HMO_one[,cols]
head(df_HMO_one)
```


```{r}
library(arules)
library(arulesViz)
HMOX <-as(df_HMO_one, "transactions")
itemFrequency(HMOX)
itemFrequencyPlot(HMOX, topN = 20)
inspect(HMOX[1:5])
```


```{r}

library(arules)
library(arulesViz)
rules1 <- apriori(HMOX,
 parameter=list(supp=0.25, conf=0.5),
 control=list(verbose=F),
 appearance=list(default="lhs",rhs=("cost_category=Expensive")))
inspectedHMOX<-inspect(rules1)
inspectedHMOX

```

```{r}
library(rio)
library(caret)
library(kernlab)

set.seed(111)
subHMO<- df_HMO_data
trainList <- createDataPartition(y=subHMO$cost_category,p=0.70,list=FALSE)

trainData <- subHMO[trainList,]
testData <- subHMO[-trainList,]
str(trainData)
```


```{r}
Tree <- train(cost_category ~smoker + bmi + age + children + location + location_type + education_level + yearly_physical + exercise + married + hypertension + gender
  , method = "rpart"
  , data =trainData) 

rpart.plot(Tree$finalModel)
Tree
```


```{r}
pred <- predict(Tree,testData) 

confusionMatrix(pred,as.factor(testData$cost_category))
```

```{r}
Tree<- train(cost_category ~smoker + bmi + age + children + location_type + education_level + yearly_physical + exercise + married + hypertension + gender
  , method = "rpart"
  , data =trainData
  , tuneLength=10) 

rpart.plot(Tree$finalModel)
```


```{r}
Tree<- train(cost_category ~smoker + bmi_category + age + children + exercise + married + hypertension + gender
  , method = "rpart"
  , data =trainData
  , tuneLength=6) 

rpart.plot(Tree$finalModel)
str(trainData)
```


