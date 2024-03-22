#Ashish Kulkarni
#FormulaOne Dataset


#install.packages("f1dataR")
#A package to access Formula 1 Data from the Ergast API and 
#the official F1 data stream via the fastf1 Python library.
#library(f1dataR) 
library(readxl)
#circuits<- load_circuits()
#constructor<- constructor_data
#drivers<-load_drivers(season = "current")

data.dir<-""

fname.raceline <- file.choose()
raceline<-read_excel(fname.raceline,sheet="Track_Plot")

Catalunya <- raceline[raceline$Track_ID=="CAT",]
Silverstone <- raceline[raceline$Track_ID=="SIL",]
Zandvoort <- raceline[raceline$Track_ID=="ZAN",]
Monza <- raceline[raceline$Track_ID=="MON",]
#-----------------------------------------------------------------------------------------
#TRACK PLOTS - Overview
#par(mfrow=c(1,3))
#plot(Catalunya$x_m,Catalunya$y_m,xlab="Catalunya",ylab = "",
 #    xaxt="n",yaxt="n")
#plot(Silverstone$x_m,Silverstone$y_m,xlab="Silverstone",ylab = "",
#     xaxt="n",yaxt="n")
#plot(Zandvoort$x_m,Zandvoort$y_m,xlab="Zandvoort",ylab = "",
#     xaxt="n",yaxt="n")

#-----------------------------------------------------------------------------------------
#TRACK PLOTS - Individual
#plot(Monza$x_m,Monza$y_m,xlab="Monza",ylab = "",
 #    xaxt="n",yaxt="n", bty="n")
plot(Monza$x_m, Monza$y_m, type="l", col="#FBC1AA", lwd=10,
     xlab="Monza", ylab="", xaxt="n", yaxt="n", bty="n")
  #plot(Catalunya$x_m,Catalunya$y_m,xlab="Catalunya",ylab = "",
 #    xaxt="n",yaxt="n", bty="n")
#plot(Silverstone$x_m,Silverstone$y_m,xlab="Silverstone",ylab = "",
#     xaxt="n",yaxt="n",bty="n")
#plot(Zandvoort$x_m,Zandvoort$y_m,xlab="Zandvoort",ylab = "",
#     xaxt="n",yaxt="n",bty="n")
#-----------------------------------------------------------------------------------------
#Track Statistics - Monza
library(dplyr)

championship.driver3 <- f1.data %>%
  filter(circuitId...30 == 14) %>%
  select(driverName, Driverwins, DNationality, time) %>%
  arrange(desc(Driverwins)) %>%
  filter(driverName %in% c("Lewis Hamilton", "Michael Schumacher", "Juan Fangio"))
colnames(championship.driver3)
championship.driver3<- c("Lewis Hamilton", 5, "British", "1:18:89",
                         "Michael Schumacher", 5, "German", "1:21.83"
                         )

#-----------------------------------------------------------------------------------------
f1.data<-read_excel(fname.raceline,sheet="Raw_data")
#Alluvial Plot
library(ggalluvial)
colnames(f1.data)
colnames(f1.data)[4]<-"CNationality"
colnames(f1.data)[20]<-"DNationality"

constructor.Lookup <- na.omit(f1.data[, 1:4])
colnames(constructor.Lookup)

constructor.Summary <- na.omit(f1.data[,5:10])
constructor.top5 <- aggregate(constructorwins ~ constructorId...7, data = constructor.Summary, FUN = sum)
class(constructor.top5$constructorwins)
constructor.top5 <- constructor.top5[order(-constructor.top5$constructorwins), ]

constructor.top5Names <- constructor.Lookup$Constructorname[constructor.Lookup$constructorId...1 %in% head(constructor.top5$constructorId...7,5)]

#custom colors for constructors
constructor.colors <- c("#FF3030","#FF4500","#FF8C00","#FFD700","#FFEC80")

filtered_constructor.Lookup <- constructor.Lookup[
  constructor.Lookup$Constructorname %in% c("McLaren", "Williams", "Ferrari", "Red Bull", "Mercedes"), 
]


p.alluvial <- ggplot(filtered_constructor.Lookup, aes(axis1 = Constructorname, axis2 = CNationality, fill = Constructorname)) +
  geom_alluvium(aes(y = ..count..)) +
  theme_minimal() +
  labs(title = "Alluvial Plot for constructorname and cNationality") +
  scale_fill_manual(values = constructor.colors)+
  theme(legend.position = "none")

color_gradient <- colorRampPalette(brewer.pal(5,"Reds"))(5)

#using colorRamp
p.alluvial <- ggplot(filtered_constructor.Lookup, aes(axis1 = Constructorname, axis2 = CNationality, fill = Constructorname)) +
  geom_alluvium(aes(y = ..count..)) +
  theme_minimal() +
  labs(title = "Alluvial Plot for Constructorname and CNationality") +
  scale_fill_manual(values = color_gradient) +  
  theme(legend.position = "none")
#----------------------------------------------------------------------------------------------------
#Curved Scatter plot

colnames(constructor.Summary)
highlighted_constructors <- constructor.Summary[constructor.Summary$constructorId...7 %in% c(1, 3, 6, 9, 131), ]

# Create the scatter plot with custom colors
ggplot(constructor.Summary, aes(x = constructorwins, y = constructorpoints)) +
  geom_point() +
  geom_point(data = highlighted_constructors, aes(color = factor(constructorId...7))) +
  labs(title = "Top 5 Constructors by Wins vs. Points", x = "Wins", y = "Points") +
  theme_minimal() +
  scale_color_manual(values = constructor.colors) +
  guides(color = guide_legend(title = "Constructor ID...7"))+
  theme(legend.position = "none")

colnames(constructor.race)
colnames(constructor.Summary)
constructor.race <- na.omit(f1.data[, 27:28])

constructor.Summary <- constructor.Summary %>%
  left_join(constructor.race, by = c("raceConstructorId" = "raceId")) %>%
  mutate(year = year)
colnames(constructor.Summary)
#Top 5

constructor.Summary %>%
  group_by(constructorId...7) %>%
  summarize(total_points = sum(constructorpoints)) %>%
  arrange(desc(total_points)) %>%
  slice_head(n = 3)

library(ggridges)
constructor.Summary_subset <- constructor.Summary %>%
  filter(constructorId...7 %in% c(6))

# Plotting the boxplot
ggplot(constructor.Summary_subset, aes(x = as.factor(year), y = constructorpoints, fill = as.factor(constructorId...7))) +
  geom_boxplot() +
  labs(title = "Time Series of Constructor Points by Year",
       x = "Year", y = "Constructor Points", fill = "Constructor ID") +
  theme_minimal()+
  facet_wrap(~ as.factor(constructorId...7), scales = "free_y")

#point plot
ggplot(constructor.Summary_subset, aes(x = year, y = constructorpoints, color = as.factor(constructorId...7))) +
  geom_point() +
  labs(title = "Time Series of Constructor Points by Year",
       x = "Year", y = "Constructor Points", color = "Constructor ID") +
  theme_minimal()+
  facet_wrap(~ as.factor(constructorId...7), scales = "free_y")

#area plot
ggplot(constructor.Summary_subset, aes(x = year, y = constructorpoints, fill = as.factor(constructorId...7))) +
  geom_area() +
  labs(title = "Time Series of Constructor Points by Year",
       x = "Year", y = "Constructor Points", fill = "Constructor ID") +
  theme_minimal()+
  facet_wrap(~ as.factor(constructorId...7), scales = "free_y")

#bar plot
ggplot(constructor.Summary_subset, aes(x = as.factor(year), y = constructorpoints, fill = as.factor(constructorId...7))) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Time Series of Constructor Points by Year",
       x = "Year", y = "Constructor Points", fill = "Constructor ID") +
  theme_minimal() +
  facet_wrap(~ as.factor(constructorId...7), scales = "free_y")


ggplot(constructor.Summary_subset, aes(x = as.factor(year), y = constructorpoints, fill = as.factor(constructorId...7))) +
  geom_bar(stat = "identity", position = "stack") +
  labs(title = "Time Series of Constructor Points by Year",
       x = "Year", y = "Constructor Points", fill = "Constructor ID") +
  theme_minimal() +
  facet_wrap(~ as.factor(constructorId...7), scales = "fixed")


#----------------------------------------------------------------------------------------------------
champs<-read_excel(fname.raceline,sheet="Champs")
barplot(champs$Championship, names.arg = champs$Drivername, beside = TRUE, col = "lightblue",
        main = "Formula 1 Championships by Driver", xlab = "Driver Name", ylab = "Number of Championships")
#----------------------------------------------------------------------------------------------------
#driver season23 heatmap
library(RColorBrewer)

s23<-read_excel(fname.raceline,sheet="S23")
colnames(s23)
HM <- s23[,-1]
HM <- as.matrix(HM)
HM<- t(HM)
HM <- HM[-nrow(HM), ]
heatmap(HM,
        Colv = NA,
        Rowv = NA,
        col = colorRampPalette(brewer.pal(9,"Reds"))(23),
        scale = "column",
        main = "Heatmap for Points in Each Race"
        )
c#----------------------------------------------------------------------------------------------------

#Map plot
#library(sf)
world_map_data <- map_data("world")
custom_red_palette <- colorRampPalette(c("red1", "darkred"))(length(unique(f1.data$country)))
ggplot() +
  geom_polygon(data = world_map_data, aes(x = long, y = lat, group = group), fill = "white", color = "black") +
  geom_point(data = f1.data, aes(x = lng, y = lat, color = country), size = 3, alpha = 0.5) +
  scale_color_manual(values = custom_red_palette) +
  theme(legend.position = "none") +
  labs(title = "F1 Data on World Map")+


#----------------------------------------------------------------------------------------------------

#colnames(constructor.Summary)
#Symbol Plot - Constructor And Driver Countries

constructors<-na.omit(f1.data[, 1:4])
#class(constructors)
colnames(constructors)
const.top10 <- head(sort(table(constructors$nationality...4),decreasing=TRUE),5)

drivers<-na.omit(f1.data[, 17:20])
#class(drivers)
colnames(drivers)
driv.top10<- head(sort(table(drivers$nationality...20),decreasing= TRUE),5)

barplot(const.top10, col = "skyblue", main = "Constructors Nationality Frequency Plot", 
        xlab = "Constructors Nationality", ylab = "Frequency", border = "black", 
        names.arg = NULL, space = 0.5, ylim = c(0, 100), pch = 19)

barplot(driv.top10, main = "Driver Nationality Frequency Plot", 
        xlab = "Drivers Nationality", ylab = "Frequency", border = "black", 
        names.arg = NULL,  ylim = c(0, 200))
#---------------------------------------------------------------------------
#Histogram - Circuit for each country
driver.points <- na.omit(f1.data[,11:16])
sort(table(map.raceTrack$country),decreasing=TRUE)
plot(table(map.raceTrack$country), ylab="Number of Circuits")
#--------------------------------------------------------------------------
library(ggplot2)
#Time Series - Races Over Years
race.years <- na.omit(f1.data[,27:32])
race.years$name <- race.years$name...31
drop(race.years$name...31)
race.years$year<-as.numeric(race.years$year)
unique.race<- data.frame(unique(race.years$name...31))

ggplot(race.years, aes(x = year, y = name)) +
  geom_line() +
  labs(title="F1 Races Over the Years",x = "Year", y = "Race Name") +
  theme_minimal()
#Parallel coordinates plot - constructor points, driver points
#star plots - Driver points, fastest lap

data <- read.transactions(data.dir, format = "basket", sep = ",", cols = c("item"))

# Run Apriori algorithm
rules <- apriori(data, parameter = list(supp = 0.1, conf = 0.8, target = "rules"))

# Inspect the top rules
inspect(sort(rules, by = "lift")[1:10])

# Visualize association rules
plot(rules, method = "graph", control = list(type = "items"))

# Create a subset of data for Lewis Hamilton and Michael Schumacher at Monza
subset_data <- data[data$driver %in% c("Lewis Hamilton", "Michael Schumacher") & data$circuit == "Monza"]
#measures dataset
# Forecast Hamilton's likelihood of having the fastest lap when winning
hamilton_win <- subset_data[subset_data$driver == "Lewis Hamilton" & subset_data$result == "1st"]
hamilton_fastest_lap <- subset_data[subset_data$driver == "Lewis Hamilton" & subset_data$fastest_lap == "Yes"]
likelihood <- nrow(hamilton_fastest_lap) / nrow(hamilton_win)
