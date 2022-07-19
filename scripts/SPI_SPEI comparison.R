####SPI_SPEI comparison code###

# #import functions
# source("functions/convert-units.R")

# load libraries
library(data.table)
library(SPEI)

#import data in data
df <- read.table("./data/corkair(81-10).csv", quote = "\"", sep=";", header=T, dec=".")
head(df)

#Extract SPI values#

df1<-tail(subset(df, YEAR > 1980 & YEAR < 2011))

spi6<-spi(df1$PRCP,6)
spi6
spi6ts<-as.data.table(spi6$fitted)
spi6ts
colnames(spi6ts)[1]<-"SPI6"
spi6ts

#Extract SPEI values#

#PET calculation
df1$PET<-hargreaves(Tmin=df1$TMIN,Tmax=df1$TMAX, lat=51.847)

#water balance calculation
WBal<-df1$PRCP-df1$PET

#create a list
spei6<-spei(WBal,6)

#display the values
spei6
spei6ts <- as.data.table(spei6$fitted)
colnames(spei6ts)[1]<-"SPEI6"
spei6ts

#Reshape data

# merge the time series with the main data table
df1$SPI6<-spi6ts$SPI6
df1$SPEI6 <- spei6ts$SPEI6
dfnew<-subset(df1, select=c(-PRCP, -PET, -TMAX, -TMIN))
head(dfnew)

# Correlation analysis of SPI anad SPEI

as.vector(dfnew$SPI6)
as.vector(dfnew$SPEI6)

result= cor.test(as.vector(dfnew$SPI6),as.vector(dfnew$SPEI6),
         method = "pearson",
         conf.level = 0.90)
print(result)
