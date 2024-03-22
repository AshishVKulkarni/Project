library(ggplot2)
library(dplyr)
library(RColorBrewer)
library(ggthemes)
library(maps)
library(mapproj)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
#data.dir<-""

x <- c(8.11,8.21,8.11,8.33,8.34,8.11,7.91,7.79,8.68,9.82,10.33,8.66,7.62,7.5,7.64,6.32,5.75,0,0.11,1.2,0.96,2.72,3.01,3.93,4.58,4.52,4.68,4.47,4.64,4.95,5.36,6.27,8.11)
y <- c(7.78,6.78,6.35,5.23,4.34,1.87,1,0.54,0.77,1.15,1.02,0.21,0,0.23,0.75,1.52,2.41,2.54,3.05,3.94,4.71,4.73,4.66,4.8,5.15,5.66,5.85,5.99,6.43,6.58,7.07,7.72,7.78)

plot(x,y,type="l")
m <- map("state")
map("world")

#m returns a function with different columns -> View more
m
class(map)

#using m to plot
plot(m$x,m$y) #Fundamentally these points draw the polygon
load(paste0(data.dir,"shootings.Rda"))


#Cleaning data using regular expression
gsub("","__HI___","Jeff Joe Hemsley") #gsub(what to find, replace it with this, in this)
shootings$State<- gsub("^\\s+|\\s+$","",shootings$State) #searches for white spaces at start and end and replaces with ""
shootings$State<-tolower(shootings$State)


df<- aggregate(shootings$Total.Number.of.Victims,
               list(shootings$State),
               sum)
df
colnames(df)<-c("region","victims")
join.data <- left_join(map_data("state"),df,by="region")

#brewer.pal.info
#choloropleth = coloring map based on data
#point map 
ggplot(join.data,aes(long,lat,group=group))+
  geom_polygon(aes(fill=victims),color="white")+
  scale_fill_gradientn(colors= brewer.pal(8,"Reds"),
                       na.value = "azure2")+
  xlab("")+ylab("")+
  theme(legend.position = "bottom",
        axis.text=element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank())+
  ggtitle("Mass Shootings in the USA")+
  coord_map("albers",at0=45.5,lat1=29.5)
#coord_flip = bars flip horizontal  


head(us.cities)

my.data <- map_data("state")
ggplot() +
  geom_polygon(data = my.data, 
               aes(x=long, y= lat, group= group),
               color="powderblue",fill="white")+
  geom_point(data=us.cities,aes(x=long,y=lat))

pal.ithun<- which(us.cities$country.etc%in%c("AK","HI"))
my.cities <- us.cities[-pal.ithun,]

#my.cities 
#data is in geom and not in gg -> for pointmap
my.data <- map_data("state")
options(scipen=99)
ggplot() +
  geom_polygon(data = my.data, 
               aes(x=long, y= lat, group= group),
               color="powderblue",fill="white")+
  geom_point(data=my.cities,
             aes(x=long,y=lat,size=pop),
             color="navyblue",alpha=0.4)+
  scale_size(name="Population", range=c(.5,8))+
  theme_map()+theme(legend.position = "bottom")+
  coord_map("albers",at0=45.5,lat1=29.5)


world_map<- map_data("world")
ggplot(world_map, aes(x=long,y=lat,group=group))+
  geom_polygon(fill="white",color="powderblue")+
  theme_map()+
  coord_map("albers",at0=45.5,lat1=29.5)

my.world <- ne_countries(scale="medium",returnclass = "sf")
theme_set(theme_map())

ggplot(data=my.world)+
  geom_sf(color="powderblue",fill="white") #sf= shape file

#View(my.world)
options(scipen=0)


ggplot(data=my.world)+
  geom_sf(aes(fill=pop_est))+ #mostly pop_est built in geom_sf
  scale_fill_gradient(low="coral",high="coral4")+
  coord_sf(crs= "+proj=laea +lat_0=52 +lon_0=10
           +x_0=4321000 +y_0=3210000
           +ellps=GRS80 +units=m +no_defs")

