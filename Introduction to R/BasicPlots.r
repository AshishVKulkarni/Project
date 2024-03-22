
#Introduction - Basics

pie(c(5,6,7,12))
#help(pie)

pie(c(5,6,7,12),main="Company X Employees")

pie(c(5,6,7,12),main="Company X Employees", labels = c("Ops","Execs", "Sales","Cleaning"))

pie(c(5,6,7,12),main="Company X Employees", labels = c("Ops","Execs", "Sales","Cleaning"),col = c("purple","turquoise","navy","grey"))

#------------------------
plot(c(9,7,5,5,4))
#help(plot)

plot(c(9,7,5,5,4),pch=17)

plot(c(9,7,5,5,4),pch=c(17,18,21,21,0))

plot(c(9,7,5,5,4),pch=c(17,18,21,21,0),cex = c(.5,4,3,3,2), col = "orange")

plot(c(9,7,5,5,4),type="l")


plot(c(9,7,5,5,4),type="h")
plot(c(9,7,5,5,4),type="h", lwd=10, col="orange")
#help(par)
#margin order = bottom, left, top, right
par(bg = "navy", mar = c(5,4,4,2), bty = "n")
plot(c(9,7,5,5,4),type="h", lwd=10, col="orange", lend = 2, ylim = c(0,10),xlab = "Random X-axis", ylab = "Heyy", col.lab = "white", col.axis = "white")

plot(c(9,7,5,5,4),type="s")
plot(c(9,7,5,5,4),type="s", lwd=5, col="orange")

#------------------------------------------

x <- c(6,7,8,9,10)
plot(x)

n <- 27
#alternative to camelCasing "."
my.lets <- sample (letters[4:6],size = n, replace =T)
barplot(table(my.lets))
barplot(my.lets)

help(barplot)
#density = no. of lines per inch
barplot(table(my.lets),width=3,space = 0.3, main = "Explore Alphabets", horiz = T, xlab ="Alphabet", ylab="Frequency", col= c("navy","orange","red"), density = c(10,20,30), angle =45, legend = T)
#---------------------------------------------------


n<- 1000
x <- rnorm(n=n, mean = 72, sd = 12)
y <- runif(n=n,min = 42,max = 92)

plot(x,y,main = "Scatter Brained")


hist(x)
#help(hist)
hist(x, main = "Unclear Histogram",breaks = 10, axes = F, labels =T, xlab="RNORM",ylab = "RUNIF", col = c(1:10), border = NA)
#---------------------------------------------------

par(mar = c(5,4,4,2))
boxplot(y,horizontal = T, col = "orange")
     
