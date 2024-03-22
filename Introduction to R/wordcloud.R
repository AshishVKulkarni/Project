library(ggplot2)
library(tidyverse)
library(dplyr)
library(RColorBrewer)
library(wordcloud)
library(ggwordcloud)
library(plotrix)

my.file<-file.choose()
#colnames(my.file)

#class(my.file)

tweets<-read.delim(my.file, quote="\"",header=TRUE,sep=",",
                    stringsAsFactors = F)
#cleanup data
View(tweets)
tweet.tags <-tweets$hashtags[tweets$hashtags != ""]

#split multiple hashtags
split_tags <- strsplit(tweet.tags,"\\|")
View(split_tags)

#unlist the split_tags - Breaks lists into single vectors
all.tags<-unlist(split_tags)
View(all.tags)

#table shows frequency, sort arranges the table
tag.df<- as.data.frame(sort(table(all.tags),decreasing = T))
View(tag.df)

#Top 10 used hashtags
tag.df[1:10,]

#hashtags used up atleast 4 times

tags<- tag.df[tag.df$Freq>4,]
View(tags)


#generating a word cloud

ggplot(tags,aes(label=all.tags))+
  geom_text_wordcloud()+
  theme_minimal()

#Color and size
ggplot(tags, aes(label=all.tags,size=Freq,col=Freq))+
  geom_text_wordcloud()+
  theme_minimal()

#Margins
ggplot(tags, aes(label=all.tags,size=Freq,col=Freq))+
  geom_text_wordcloud(area_corr = TRUE)+
  theme_minimal()+
  scale_size_area(max_size = 20,limits=c(4,NA))

#radius of the word cloud
ggplot(tags, aes(label=all.tags,size=Freq,col=Freq))+
  geom_text_wordcloud()+
  theme_minimal()+
  scale_radius(range= c(1,18),limits=c(4,NA))


#using wordcloud and plotrix library

View(all.tags)

tag.tab<-sort(table(all.tags),decreasing = T)
View(tag.tab)

#breakdown the tag.tab data frame
#looking at the vectors in all.tags without looking for frequency

tag.word <- names(tag.tab)
View(tag.word)

#change characters to numbers
tag.freq<-as.numeric(tag.tab)

#make a wordcloud using library
wordcloud(tag.word,tag.freq,
          scale=c(5,0.5))


#scaling problem

tag.tab[1]
#shows the data that follows the power-law distribution
plot(tag.freq,main="No scaling")

#log to work on power-law distribution
#y axis comes down from 3000 to 3.5
plot(log10(tag.freq),main="log10 Scaling")


par(mfrow= c(2,3))
plot(tag.freq,main="No scaling")
plot(log10(tag.freq),main="log10 Scaling")
plot(tag.freq/max(tag.freq),main = "0-1 scale")
plot(tag.freq^2,main="Square Scale(UP)")
plot(tag.freq^1/2,main="SquareRoot Scale(Down)")
plot(tag.freq^1/5,main="Scale 1/5 power")



#base of wordcloud using library wordcloud

#square root of 0.25 = 0.5
#square root of 25 = 5

size <- round(9*sqrt(tag.freq/max(tag.freq)),0)+1
range(size)
            
par(mfrow = c(1,1))  
wordcloud(tag.word,size,
          scale=c(5,0.5), min.freq = 2, max.words = Inf)

my.col.pat <- colorRampPalette(c("yellow","red","green"))
tag.col <- my.col.pat(max(size))[size]

par(mar=c(0,0,0,0),bg="black")
wordcloud(tag.word,size,
          scale=c(5,0.5), min.freq = 2, max.words = Inf,
          random.order = FALSE, ordered.colors = TRUE, colors = tag.col )
