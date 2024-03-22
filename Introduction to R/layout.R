# Design with Layout
library(ggplot2)

#data.dir <- ""
sales <- read.csv(paste0(data.dir,"sales.csv"))

x <- 1:24
y <- rnorm(length(x))
A <- runif(n=length(x), min=2,max=9)
A <- A+y^2
B <- sample(c("D","W"),size = length(x),replace = T)

#Layout design using matrix
M <- matrix(
  c(1,4,3,
    1,1,3,
    2,2,3), nrow = 3, byrow = T
) #byrow fills the matrix row-wise
M

layout(M)
layout.show(n=4) #n signifies the plot divisions

par(mar=c(5,4,4,2))

#default 5,4,4,2
par(mar=c(0,4,4,2),bty="n")
plot(x,y,type="l",xaxt="n",ylab="",xlab = "",
     ylim=c(1.3*min(y),1.3*max(y)), col="darkred")

par(mar=c(5,4,0,2))
barplot(A,names.arg = 1:length(x),border = NA,
        col="wheat4")

par(mar=c(4,4,4,4),bty="n")
boxplot(A~B,col="brown")

pie(table(B),col=c("darkred","wheat4"))



sales$price <- "cheap"
sales$price[sales$unit.price > 10] <- "mid"
sales$price[sales$unit.price > 14] <- "high"


p1<- ggplot(sales)+
  aes(y=income,x=expenses,color=price)+
  geom_point()+
  geom_smooth()+
  theme_minimal()

p2<- ggplot(sales)+
  aes(x=expenses, fill = price)+
  geom_histogram(alpha=0.8)+
  theme_minimal()

library(ggpubr)
ggarrange(p1,p2,nrow=2)

p3<- ggplot(sales)+
  aes(income)+
  geom_boxplot()+
  coord_flip()+
  theme_minimal()

ggarrange(p1,p3,p2,nrow=2,ncol=2)

ggarrange(p1,p3,p2,nrow=2,ncol=2,
         heights=c(1.5,.8),
         widths=c(1.5,.8))

p4<- ggplot(sales)+
  aes(x=rep.region, fill= type)+
  geom_bar(position = "dodge")+
  theme_minimal()


ggarrange(p4,p3,p2,p1,nrow=2,ncol=2,
          heights=c(2.5,1.5),
          widths=c(1.5,.8))

#climateTweets_UseForLecture_25K.csv
fname <-file.choose()
tweets <- read.csv(fname)
summary(tweets)
str(tweets)

tweets$created_at[1:3]


strptime(tweets$created_at[1:3],
         #"Mon Aug 15 13:05:42 +0000 2016"
         "%a %b %d %H:%M:%S +0000 %Y")


#For instance
strptime("Pokemon 1997 was 12/11",
         "Pokemon %Y was %m/%d")

?strptime()

my.dates<- strptime(tweets$created_at,
          "%a %b %d %H:%M:%S +0000 %Y")
#Range- Method 1
max(my.dates) - min(my.dates)

#Range - Method 2
range(my.dates)


as.Date(my.dates)
class(my.dates)


barplot(table(as.Date(my.dates)))

library(lubridate) #helps working with dates
#help(lubridate)
year(my.dates)
barplot(table(hour(my.dates)))
