################
#   Gráficos   #
################


'
Script modificado a partir de la clase tutorial de 
"Herramientas computacionales para la Investigación"
dictada por Amelia Gibbons en la Universidad de San Andrés.
'

'
Prior to use, install the following packages:
install.packages("ggplot2")
install.packages("tibble")
install.packages("dplyr")
install.packages("gridExtra")
install.packages("Lock5Data")
install.packages("ggthemes")

install.packages("maps")
install.packages("mapproj")
install.packages("corrplot")
install.packages("fun")
install.packages("zoo")

Used datafiles and sources:
a) gapminder.csv - Modified dataset from various datasets available at:
https://www.gapminder.org/data/
b) xAPI-Edu-Data.csv:
https://www.kaggle.com/aljarah/xAPI-Edu-Data/data
c) LoanStats.csv:
Loan Data from Lending Tree - https://www.lendingclub.com/info/download-data.action
d) Lock5Data
'

#Load Libraries
library("ggplot2")
library("tibble")
library("gridExtra")
library("dplyr")
library("Lock5Data")
library("ggthemes")
library("fun")
library("zoo")
library("corrplot")
library("maps")
library("mapproj")

#Set pathname for the directory where you have data
setwd("C:/Users/Pc__/Desktop/Herramientas computacionales/Clase 5/video 1/Applied-Data-Visualization-with-R-and-ggplot2-master")
#Check working directory
getwd()

#Note: Working directory should be "Beginning-Data-Visualization-with-ggplot2-and-R"

#Load the data files
df <- read.csv("data/gapminder-data.csv")
df2 <- read.csv("data/xAPI-Edu-Data.csv")
df3 <- read.csv("data/LoanStats.csv")

#Summary of the three datasets
str(df)
str(df2)
str(df3)

###############
# Histogram 1 # --> no lo mostramos
###############

#Subtopic - Layers
p1 <- ggplot(df,aes(x=Electricity_consumption_per_capita))
p2 <- p1+geom_histogram(alpha = 0.99,  col = "black", fill="darkslategray4", bins = 10)
p2

#Labels and title
p3 <- p2+xlab("Electricity consumption per capita")+ylab("Count")+ggtitle("Consumption of Electricity")
p3

############### 
# Scatter plot #
###############

p <- ggplot(df, aes(x=gdp_per_capita, y=Electricity_consumption_per_capita)) + 
  geom_point()

#Labels,title and scale
p + facet_wrap(~Country, scales="free")+labs(x="GDP per capita", y="Electricity consumption per capita", title="Electricity consumption and GDP (by countries)")

###############
# Histogram 2 #
###############

#We want to look at the distribution of loan amounts for different credit grades.
df3s <- subset(df3,grade %in% c("A","B","C","D","E","F","G"))
pb1<-ggplot(df3s,aes(x=loan_amnt))
pb1
pb2<-pb1+geom_histogram(bins=10,fill="darkslategray4", col="black", alpha=0.99)
pb2

#Labels and title
pb3 <-pb2+xlab("Loan amount (dollars)")+ylab("Count")+ggtitle("Number and amount of loans (by credit grade)")
pb3

#Facet wrap
pb4<-pb3+facet_wrap(~grade) 
pb4

#Free y coordinate for the subplots
pb5<-pb4+facet_wrap(~grade, scale="free_y")
pb5


##################
# Scatter plot 2 #
##################

#Using color to group points by variable
dfs <- subset(df,Country %in% c("Germany","India","China","United States"))
var1<-"Electricity_consumption_per_capita"
var2<-"gdp_per_capita"
name1<- "Electricity consumption per capita"
name2<- "GDP per capita"

# Change color of points and insert labels
p1<- ggplot(dfs,aes_string(x=var1,y=var2))+
  geom_point(aes(color=Country))+xlim(0,10000)+ylim(0,42000)+xlab(name1)+ylab(name2)+ggtitle("Electricity consumption and GDP per capita")
p1

