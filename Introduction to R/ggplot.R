
#GGPLOT - Grammar of Graphics

fname.sales <- file.choose() #art.csv
sales <- read.csv(fname.sales, stringsAsFactors = FALSE) #read csv into new df

#data.dir<-""

hist(sales$income)

library(ggplot2)
ggplot(sales,aes(x=income))+geom_histogram()

#same as 
ggplot(sales) +
  aes(x=income)+
  geom_histogram()

ggplot(sales) #sets the plotting space

p<-ggplot(sales)
class(p)
names(p)
attributes(p) #class + names 
p$data  #ggplot creates a extract copy of the data, raising the possibility of memory overload
#ensure data is filtered down before passing to ggplot

p<-ggplot(sales)+aes(x=income)
p$mapping


plot(sales$expenses,sales$income)
#using gg

ggplot(sales)+aes(x=expenses,y=income)+geom_point()
#same as below. Mapping order does not matter
ggplot(sales)+aes(y=income,x=expenses)+geom_point()
#when done in geom_xyz(), it is called as setting an aesthetic
#when done in aes(), it is called as mapping an aesthetic
ggplot(sales)+aes(y=income,x=expenses)+geom_point(color="orange",size=3)

ggplot(sales)+aes(y=income,x=expenses,color=type)+geom_point(size=3)
#setting > mapping
ggplot(sales)+aes(y=income,x=expenses,color=type)+geom_point(color="orange",size=3)

ggplot(sales)+aes(y=income,x=expenses,color=type)+geom_point()

#alpha = sets transparency
ggplot(sales)+
  aes(y=income,x=expenses,color=year,shape=type ,size = units.sold, alpha = rep.region)+
  geom_point()

p<-ggplot(sales)+aes(x=expenses,y=income, color=unit.price < 9) +
  geom_point()
p + scale_color_manual(values = c("wheat4","grey6"))+
  geom_rug(color="grey5")


income.pred<- predict(lm(sales$income~sales$expenses))

ggplot(sales)+aes(x=expenses,y=income) +
  geom_point()+
  geom_line(aes(y=income.pred),color="wheat4",lwd=2)

ggplot(sales)+aes(x=expenses,y=income) +
  geom_point()+
  geom_smooth()

ggplot(sales)+aes(x=expenses,y=income) +
  geom_hex()

library(viridis)
ggplot(sales)+aes(x=expenses,y=income) +
  geom_hex()+
  scale_fill_viridis(option = "turbo")

ggplot(sales)+aes(x=expenses,y=income) +
  geom_hex()+
  scale_fill_viridis(option = "magma")

ggplot(sales)+aes(x=expenses,y=income) +
  geom_hex()+
  scale_fill_viridis(option = "cividis")

ggplot(sales)+aes(x=expenses,y=income) +
  geom_hex()+
  scale_fill_viridis(option ="inferno")

library(RColorBrewer)
ggplot(sales)+aes(x=expenses,y=income) +
  geom_hex()+
  scale_fill_gradientn(colors = rev(brewer.pal(6,"Purples")))

display.brewer.all()


library(ggExtra)
p<-ggplot(sales)+aes(x=expenses,y=income) +
  geom_point(alpha=0)+
  geom_hex()+
  scale_fill_gradientn(colors = rev(brewer.pal(6,"Purples")))
ggMarginal(p,type = "histogram",
           fill = brewer.pal(6,"Purples")[5], color = "white" )


price <- ifelse(sales$unit.price > 14, "High", "Med")
price[sales$unit.price<9]<-"Low"

#using color
ggplot(sales)+
  aes(y=income,color=price,x=expenses)+
  geom_bin2d(bins=50)

#using fill
ggplot(sales)+
  aes(y=income,fill=price,x=expenses)+
  geom_bin2d(bins=50)


ggplot(sales)+
  aes(y=income,color=price,x=expenses)+
  geom_point()+
  scale_color_manual(values=c("yellow3","green1","darkgreen"  ))+
  theme_minimal()


ggplot(sales)+
  aes(y=income,color=price,x=expenses)+
  geom_point()+
  scale_color_manual(values=c("chocolate1","chocolate3","chocolate4"  ))+
  theme_bw()+
  facet_grid(rep.region~.) #rowise grid

ggplot(sales)+
  aes(y=income,color=price,x=expenses)+
  geom_point()+
  scale_color_manual(values=c("chocolate1","chocolate3","chocolate4"  ))+
  theme_bw()+
  facet_grid(.~rep.region) #columnwise grid

ggplot(sales)+
  aes(y=income,color=price,x=expenses)+
  geom_point()+
  scale_color_manual(values=c("chocolate1","chocolate3","chocolate4"  ))+
  theme_bw()+
  facet_grid(wine~rep.region) + #crosstab plot
  ggtitle("IST 719: FacetGrid and Title")

#density plot
#grouping by method 1
ggplot(sales)+
  aes(x=income)+
  geom_density() + #good way to show distribution
  facet_grid(rep.region~.)

#grouping by method 2 - add mapping parameter
ggplot(sales)+
  aes(x=income,fill=rep.region)+
  geom_density(alpha=.2)+
  theme_bw()

#BoxPlot
ggplot(sales)+
  aes(x=income, fill=rep.region)+
  geom_boxplot()+
  facet_grid(rep.region~.)+ #this method works good because we are usually checking median
  theme_classic()

#Violin Plot -> used to show distribution
library(viridis)
ggplot(sales)+
  aes(x=rep.region,y=income, 
      fill=rep.region,color=rep.region)+
  geom_violin()+
  stat_summary(fun=mean,geom="point",
               shape=8,size=6,color="white")+
  stat_summary(fun=median,geom="point",
               shape=16,size=4,color="white")+
  theme_classic()+
  scale_color_manual(values=viridis(5))+
  scale_fill_manual(values=viridis(5))+
  theme(legend.position = "bottom")+
  ggtitle("Sales Income Distribution by region")
#Design Choice
#theme(legend.position = "top")+
# theme(legend.position = "left")+
# theme(legend.position = "right")

#Timeseries - Lineplot
df.year <- aggregate(sales$units.sold,list(year=sales$year),sum)
df.year.2 <- aggregate(sales$units.sold,list(year=sales$year,region=sales$rep.region),sum)

ggplot(df.year.2)+
  aes(x=year,y=x,color=region)+
  geom_line(linewidth=3)+
  ylim(c(0,10000))+
  theme_classic()+
  scale_color_manual(values=viridis(5))+
  ggtitle("Line Plot")


library(maps)
world_map <-map_data("world")
ggplot(world_map)+
  aes(x=long,y=lat,group=group)+
  geom_polygon(fill="wheat1",color="wheat4")

head(world_map) #group variable helps aggregate per region here


#barplot
#stat is what helps geom() figure what out to plot based on calculations
#Here in this case geom_bar() by default plots table()
ggplot(sales)+
  aes(x=rep.region)+
  geom_bar()


income.df <- aggregate(sales$income, list(reg = sales$rep.region),sum)
ggplot(income.df)+
  aes(x=reg,y=x)+
  geom_bar(stat = "identity") #uses the number that we aggregated else uses default stat


ggplot(sales)+
  aes(x=rep.region,fill=type)+
  geom_bar(position = "dodge") #same as besides = true

unitSold.df <- aggregate(sales$units.sold, list(reg = sales$rep.region,type=sales$type),sum)
head(unitSold.df)
ggplot(unitSold.df)+
  aes(x=reg,y=x,fill=type)+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_manual(values=viridis(5))+
  theme_bw()+
  ggtitle("Bar Plot - Aggregate")+
  theme(legend.position = "top")

ggplot(unitSold.df)+
  aes(x=x,y=reg,fill=type)+
  geom_bar(stat="identity",position="dodge")+
  scale_fill_manual(values=inferno(2))+
  theme_bw()+
  ggtitle("Bar Plot - Aggregate")+
  theme(legend.position = "top")


df<-aggregate(sales$income,list(region=sales$rep.region),sum)

colnames(df)[2] <- "income"

ggplot(df)+
  #aes(x=region,y=income,fill=region)+
  aes(x="",y=income, fill=region)+
  geom_bar(stat="identity",width=.3)+
  coord_polar("y",start=45)+
  theme_bw()

df<-aggregate(sales$units.sold,list(region=sales$rep.region),sum)
colnames(df)[2] <- "units"

o <- order(df$units,decreasing = FALSE)
df<- df[o,]
df$region <- factor(df$region, levels = df$region) #study what factor does

#color palette
my.color.pal <- colorRampPalette(c("wheat1","wheat4"))

ggplot(df)+
  aes(x=region,y=units,fill=region)+
  geom_bar(stat="identity",width = 0.95)+
  coord_polar(theta="y")+ ylim(c(0,47000))+
  xlab("")+ylab("")+
  theme(axis.text.y = element_blank(),legend.position = "none",
        panel.background = element_blank(),
        axis.ticks = element_blank())+
  scale_fill_manual(values=my.color.pal(5))+
  geom_text(data=df,hjust=1.1,size=5,
            aes(x=region,y=0,label=region))+
  ggtitle("The amazing curved barplot")


