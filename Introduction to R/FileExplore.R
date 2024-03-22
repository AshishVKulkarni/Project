#Files and Exploring data

getwd()
#help(getwd)

#help(file.choose)
#file.choose() opens pathway selection window
fname <- file.choose() #returns a qualified path

tips<-read.csv(fname)

fname #returns the entire path for the file here

data.dir<- paste0(dirname(fname),"/") 
#returns the directory path (penultimate path) of the file 
#help(paste0)      

paste("Ashish","Kulkarni",letters[1:5]) #by default strings with space
paste0("Ashish","Kulkarni",letters[1:5]) #strings without space

paste("Information","Visualization",sep = "$")

paste(letters[1:3],LETTERS[1:3])

x<- sample(paste("Var",1:10,sep="-"),size = 100, replace = T)
barplot(table(x))


list.files(data.dir)
#help(list.files)


tips<- read.csv(paste0(data.dir,"tips.csv"))

View(tips)
tips
head(tips)
tail(tips)
str(tips)
colnames(tips)
rownames(tips)
dim(tips)
nrow(tips)

fix(tips)  #updates data in-memory(extract), does not affect the source data
#halts all scripts until open

plot(tips$tip)


#--------------------

wine<- read.delim(paste0(data.dir,"Wine.txt"),sep="\t")
View(wine)
wine
head(wine)
tail(wine)
str(wine)
colnames(wine)
rownames(wine)
dim(wine)
nrow(wine)

#extract a copy of data env
save(tips,wine,fname,x,file=paste0(data.dir,"Ashish_Lab2_Env.rda"))
#help(save)

#loads the env, overwrite if preexisting
#load(paste0(data.dir,"Ashish_Lab2_Env.rda"))

rm(wine)
#remove specified data, 
ls()



tips$tip
tips[,3]
#tips[3]
tips[,"tip"]

tips[,3:4]
tips$tip

#plotting distribution
par(mfrow=c(3,2))  #multiframe row-wise framing
plot(tips$tip)
hist(tips$tip)
boxplot(tips$tip)
plot(sort(tips$tip))
plot(density(tips$tip))

summary(tips$tip)

unique(tips$sex)
table(tips$sex)
f.tips<- tips$tip[tips$sex == "Female"]
m.tips<- tips$tip[tips$sex == "Male"]

par(mfrow=c(2,1))
#plot(sort(f.tips), col= "pink", bg="skyblue")
#plot(sort(m.tips), col= "skyblue", bg="pink")
hist(main="Tips - Female Customers",f.tips, col = "pink", ylim = c(0,50),xlim= c(0,12), breaks =10)
abline(v = median(f.tips), col = "red", lwd=2)
hist(main="Tips - Male Customers",m.tips, col = "skyblue", ylim = c(0,50),xlim= c(0,12), breaks =10)
abline(v = median(m.tips), col = "red", lwd=2)
