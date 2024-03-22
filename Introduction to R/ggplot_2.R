
library(ggplot2)
library(tidyverse)
library(ggmosaic)
library(treemapify)
library(ggalluvial)
library(circlize)
library(ggthemes)
library(ggbeeswarm)
library(ggpubr)

sales<-read_csv(file.choose())
colnames(sales)

#View(sales)

#sales of each region
ggplot(sales)+
  aes(x=rep.region,y=income, fill = rep.region)+
  geom_boxplot()

#Subsetting for 2010
sales2 <- sales[sales$year == 2010,]

#Expense per region for 2010
ggplot(sales2)+
  aes(x=rep.region,y=expenses,color=rep.region)+
  geom_point()

#beeswarm
p.beeswarm<-ggplot(sales2,aes(x=rep.region,y=expenses, color=rep.region))+geom_beeswarm()

#custom colors
my.color <- c("steelblue","steelblue2","steelblue3","steelblue4","snow4")

#cex = space between the points
#size = size of the points
p.beeswarm<-ggplot(sales2,aes(x=rep.region,y=expenses, color=rep.region))+
  geom_beeswarm(cex=2,size=0.2,priority = "density")+
  scale_color_manual(values=my.color)+
  theme_minimal()

#plot2 area plot
reg.year <- aggregate(sales$units.sold,
                      list(year=sales$year,
                           reg=sales$rep.region),
                      sum)
#change column names
colnames(reg.year)[3]<-"units"
colnames(reg.year)

#using tidyverse
reg.year2<- sales%>%group_by(year,reg=rep.region)%>%
  summarise(units=sum(units.sold))
class(reg.year2)

#creating an area plot

p.area <- ggplot(reg.year)+
  aes(x=year,y=units,fill=reg)+
  geom_area()+
  scale_fill_manual(values=my.color)+
  theme_minimal()

p.line <- ggplot(reg.year)+
  aes(x=year,y=units,color=reg)+
  geom_line()



#Mosaic Plot
wine.reg <- aggregate(sales$units.sold,
                      list(wine=sales$wine,
                           reg=sales$rep.region),
                      sum)
colnames(wine.reg)
colnames(wine.reg)[3]<-"units"


#Basic Mosaic plot
p.mosaic1 <- ggplot(wine.reg) +
  geom_mosaic(aes(x=product(wine),
                  weight=units, fill = reg))
#weight = determines size of rectangle
#product = deteremines the partition of rectangle

#better looking mosaic plot
p.mosaic2 <- ggplot(wine.reg) +
  geom_mosaic(aes(x=product(wine),
                  weight=units, fill = reg))+
  scale_fill_manual(values = my.color)+
  theme(axis.text = element_text(angle = 45,hjust = 1))+
  coord_flip()+
  theme(legend.position = "none")

#just x axis tilt
p.mosaic2 <- ggplot(wine.reg) +
  geom_mosaic(aes(x=product(wine),
                  weight=units, fill = reg))+
  scale_fill_manual(values = my.color)+
  theme(axis.text.x = element_text(angle = 45,hjust = 1))


#tree plot
wine.reg.type <- aggregate(sales$units.sold,
                      list(wine=sales$wine,
                           reg=sales$rep.region,
                           type= sales$type),
                      sum)
colnames(wine.reg.type)[4]<-"units"
#area=size of rectangle and subgroup = smaller rectangle within area 
p.tree <- ggplot(wine.reg.type)+aes(area=units,fill=reg,subgroup=reg)+
  geom_treemap()+
  geom_treemap_subgroup_text(color="white")+
  geom_treemap_text(aes(label=wine),color="black")+
  guides(fill=FALSE)+
  scale_fill_manual(values = my.color)



#Alluvial Plot

p.alluvial <- ggplot(wine.reg.type)+aes(axis1=reg,axis2=wine,axis3=type,
                                        y=units)+
  geom_alluvium(aes(fill=reg))+
  #stratum adds the boxes as axis
  geom_stratum()+
  geom_text(stat = "stratum", aes(label = after_stat(stratum)))+
  theme_minimal()+
  scale_fill_manual(values = my.color)


#Diverging Bar Plot / Pyramid Plot
plot(sales$units.sold)
#cut = divide data into groups with same interval
sales$cuts <- cut(sales$units.sold,seq(0,50,5))

#frequency count of units sold for each interval for gender
table(sales$cuts,sales$rep.sex)


pop.df<- aggregate(sales$income,
                   list(rep.sex=sales$rep.sex,
                        units=sales$cuts),
                   sum)
colnames(pop.df)[3]<-"income"

#changing 0-1 to female & male

pop.df$rep.sex[pop.df$rep.sex== 0] <- "Female"
pop.df$rep.sex[pop.df$rep.sex== 1] <- "Male"
#negative values so that Female income is shown on the left side and male income on right side of 0
pop.df$income[pop.df$rep.sex=="Female"] <- pop.df$income[pop.df$rep.sex=="Female"] * -1

#Figuring out the x-axis for plot
#353168.2 - 400,000
max(abs(range(pop.df$income)))
options(scipen = 99)
col1 <- my.color[1]
col2 <- my.color[2]

p.pyr <- ggplot(pop.df)+aes(x=units,y=income,fill=rep.sex)+
  geom_bar(stat="identity")+
  coord_flip()+
  scale_y_continuous(breaks = seq(-400000,400000,100000),
  labels=as.character(abs(seq(-400000,400000,100000))),
  limits=c(-400000,400000))+
  scale_fill_manual(values=c(col1,col2))+
  theme_minimal()+
  xlab("Units Sold")+ylab("Sales Income")


ggarrange(p.beeswarm,p.area,p.mosaic2,p.tree,p.alluvial,p.pyr,
      nrow=3,ncol=2)
