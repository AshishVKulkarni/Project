#Adobe Illustrator used for the visualizations

n<- 1000
y<- rnorm(n,mean=72,sd=8)
x<- rnorm(n,mean=42,sd=6)


par(xpd= FALSE)
plot(x,y,xlim=c(35,50))
plot(x,y)


A <- sample(c("hi","low","go","joe"),
            size=100,
            prob=c(35,30,20,15),
            replace= TRUE)
B<- sample(c("now","later"),
            size=100,
           prob = c(60,40),
           replace=TRUE)

barplot(table(B,A),beside=TRUE)

pie(table(A))
