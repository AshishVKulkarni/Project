
#Multi Dimension plots, other cool stuff

#data.dir <- ""

sales <- read.csv(paste0(data.dir,"sales.csv"))
colnames(sales)

#what is the relationship between expenses and income

str(sales$expenses)
str(sales$income)
head(sales$expenses)
head(sales$income)

#2 measures usually use scatterplot
#cause/driver/predictor on X, action/outcome on Y
plot(sales$expenses,sales$income)
abline(lm(sales$income ~ sales$expenses), col = "red", lwd=3)
#positive relationship, in this case, more money spent is more money earned
abline(h=mean(sales$income),col="blue")
abline(v=mean(sales$expenses),col="blue")
#abline(V) = vertical line
#abline(h) = horizontal line
#side:1= bottom, 2=left,3=top,4=right
rug(sales$income,side=2,col="pink")
rug(sales$expense,side=1,col="orange")
#help(rug)
mtext("Scatter Plot Exploration", side=4,line=1,cex = 1.3) #margin text
mtext("The everything Plot ", side=3,line=2,cex = 1.7)
text(x=8,y=800, labels = "Random",col= "purple",cex=2) #text to plot

#What is relationship between income and type

str(sales$type)
table(sales$type)
str(sales$income)
#~ implies a formula
boxplot(sales$income ~ sales$type)
abline(h=mean(sales$income),col="red",lty=3)
abline(h=median(sales$income),col="blue",lty=2)
#boxplot is a more easier way to showcase categorical and numerical relation


#which region sells the most units

unique(sales$rep.region)
View(sales)

sum(sales$units.sold[sales$rep.region == "West"])
sum(sales$units.sold[sales$rep.region == "East"])
sum(sales$units.sold[sales$rep.region == "Central"])
sum(sales$units.sold[sales$rep.region == "North"])
sum(sales$units.sold[sales$rep.region == "South"])

units.ref.df<-aggregate(sales$units.sold, list(sales$rep.region),sum) #aggregrate returns a df

class(units.ref.df)
colnames(units.ref.df)<-c("reg","units")
#par(mfrow=c(1,2))
barplot(units.ref.df$units,names.arg = units.ref.df$reg)


units.ref.M<-tapply(sales$units.sold, list(sales$rep.region),sum) #tapply returns a matrix
barplot(units.ref.M)


units.ref.df
units.ref.M

#How do the units sold of red vs white wine differ by region

#units=numeric
#region = cat
#type = cat
units.ref.type.M<- tapply(sales$units.sold,list(sales$rep.region,sales$type),sum)
#stacked bar chart
barplot(units.ref.type.M)
barplot(units.ref.type.M,beside=TRUE)

units.ref.type.M<- tapply(sales$units.sold,list(sales$type,sales$rep.region),sum)
#stacked bar chart
barplot(units.ref.type.M)
barplot(units.ref.type.M,beside=TRUE,legend.text = rownames(units.ref.type.M))


#Is income growing over time for each region?

timeseries.M <- tapply(sales$income,list(sales$rep.region,sales$year),sum)
x<- as.numeric(colnames(timeseries.M))
options(scipen = 99) #overrides scientific notations
plot(x,timeseries.M[1,],xlab="Years",ylab = "income",type="l",ylim=c(0,max(timeseries.M)),
     col="red",lwd=3,bty="n")
lines(x,timeseries.M[2,],col="orange",lwd=3)
lines(x,timeseries.M[3,],col="blue",lwd=3)
lines(x,timeseries.M[4,],col="darkgreen",lwd=3)
lines(x,timeseries.M[5,],col="purple",lwd=3)
mtext("Wine Over Time",side=3,line=2,cex=1.5,lwd=3)

legend("bottomleft",legend=rownames(timeseries.M),lwd=3,col=c("red","orange","blue","darkgreen","purple"))
