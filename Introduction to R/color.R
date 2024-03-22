# Working with color
data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAABIAAAASCAYAAABWzo5XAAAAWElEQVR42mNgGPTAxsZmJsVqQApgmGw1yApwKcQiT7phRBuCzzCSDSHGMKINIeDNmWQlA2IigKJwIssQkHdINgxfmBBtGDEBS3KCxBc7pMQgMYE5c/AXPwAwSX4lV3pTWwAAAABJRU5ErkJggg==
#data.dir <- ""
sales <- read.csv(paste0(data.dir,"sales.csv"))

library(RColorBrewer)
display.brewer.all()
rand.data <- replicate(8,rnorm(27,1.7))
boxplot(rand.data,col=brewer.pal(8,"BuGn"))

#More  the value of something, lighter the shade, opposite to irl
#RRGGBB
pie(c(1,1,1),col=c("#FF0000","#00FF00","#0000FF"))
pie(c(1,1,1),col=c("#AA0000","#00FF00","#0000FF"))
pie(c(1,1,1),col=c("#660000","#00FF00","#0000FF"))
pie(c(1,1,1),col=c("#000000","#ffFFFF","#F0a040"))

pie(c(1,1,1),col=c("#ffaaa7","#f0a0ff","#ff0077"),
    labels= c("#ffaaa7","#f0a0ff","#ff0077"))

#Takes 2 color as start and end of a colorscale which it ramps up to step by step
#colorRampPalette builds a function and gives vales between start and end of colors
#On running just the FUN in this case, we get
#function (n) 
#{
#  x <- ramp(seq.int(0, 1, length.out = n))
#  if (ncol(x) == 4L) 
#    rgb(x[, 1L], x[, 2L], x[, 3L], x[, 4L], maxColorValue = 255)
#  else rgb(x[, 1L], x[, 2L], x[, 3L], maxColorValue = 255)
#}

FUN <- colorRampPalette(c("#CAFF70","#BF3EFF"))
boxplot(rand.data,col=FUN(8))

plot(sales$expenses,sales$income)
#one way to figure out clusters in overplotting
plot(sales$expenses,sales$income,pch = 16, cex=0.3)
#Alternatively use rgb()
my.col <- rgb(.8,.15,.15, alpha = .1)
plot(sales$expenses, sales$income,pch=16,
     cex=.5,col=my.col,main="Overplotting solutions")

#Factor Finding - Color points in this plot based on some other factor in the data
colnames(sales)
my.vec <- rep(x=rgb(.8,.15,.15),nrow(sales)) #rep ~ replicate
my.vec[sales$type == "white"] <-rgb(.15,.15,.8)

plot(sales$expenses, sales$income,pch=16,
     cex=.5,col=my.vec)


my.vec <- rep(x=rgb(.8,.15,.15),nrow(sales)) #rep ~ replicate
my.vec[sales$unit.price > 10] <-rgb(.15,.15,.8)
my.vec[sales$unit.price > 14] <-rgb(.15,.8,.15)

plot(sales$expenses, sales$income,pch=16,
     cex=.5,col=my.vec)


my.col.1<- rgb(152, 251, 152, maxColorValue = 255)
my.col.2<- rgb(124, 205, 124, maxColorValue = 255)
my.col.3<- "#4EEE94"
my.col.4<- rgb(46, 139, 87, maxColorValue = 255)

col.vec.2=c(my.col.1,my.col.2,my.col.3,my.col.4)
pie(c(1,1,1,1),col=col.vec.2, main="Mixed Color Pie")


colnames(agg.data)[3] <-"units"
agg.data <- aggregate(sales$units.sold,list(type=sales$type,
                                            wine=sales$wine),sum)
agg.data$color <- "green"
agg.data$color[agg.data$type=="red"]<-"#800020"
agg.data$color[agg.data$type=="white"]<-"#f9e8c0"

par(mar=c(5,9,4,1))
barplot(agg.data$units,names.arg = agg.data$wine,
        horiz = T, las = 1, col = agg.data$color, main= "Using Specific Colors")

tmp.agg<- aggregate(sales$income,
                    list(type=sales$type,
                         wine=sales$wine),
                    sum
                  )

options(scipen=99)
agg.data$income <- tmp.agg$x
par(mar=c(5,4,4,2),bty="n")
plot(agg.data$units,agg.data$income,
     xlim=c(0,(1.25*max(agg.data$units))),
     ylim=c(0,(1.25*max(agg.data$income))),
     xlab="Units Sold", ylab="Income",
     main="ACME Wine Co. Sales")

library(png)
ima<- readPNG(paste0(data.dir,"bottles.png"))
r1<-readPNG(paste0(data.dir,"r1.png"))
w1<-readPNG(paste0(data.dir,"w1.png"))

#Coordinates of user plot space
lim<- par()
lim
usr <- lim$usr

plot(agg.data$units,agg.data$income,
     xlim=c(0,(1.25*max(agg.data$units))),
     ylim=c(0,(1.25*max(agg.data$income))),
     xlab="Units Sold", ylab="Income",
     main="ACME Wine Co. Sales")

#usr x1,y1,x2,y2
rasterImage(ima,usr[1],usr[3],usr[2],usr[4])
rect(usr[1],usr[3],usr[2],usr[4],
     col=rgb(1,1,1,.85),border="white")


r1.x1 <- agg.data$units[agg.data$type=="red"]
r1.x2 <- r1.x1+3000
r1.y1 <- agg.data$income[agg.data$type=="red"]
r1.y2 <-r1.y1+65000
rasterImage(r1,r1.x1,r1.y1,r1.x2,r1.y2)


r2.x1 <- agg.data$units[agg.data$type=="white"]
r2.x2 <- r2.x1+3000 #3000 gives the width of the glass
r2.y1 <- agg.data$income[agg.data$type=="white"]
r2.y2 <-r2.y1+65000 #65000 gives the height of the glass
rasterImage(w1,r2.x1,r2.y1,r2.x2,r2.y2)


#text(r1.x1,y=r1.y1,agg.data$wine[agg.data])
#help(text)
text(agg.data$units+3000,
     agg.data$income+10000,
     labels=agg.data$wine,
     adj=0,cex=1.2) #adj = left or right, default - 0.5
