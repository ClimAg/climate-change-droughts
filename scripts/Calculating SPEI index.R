setwd("D:/evakl/Bureau/Moore park essais/")
df <- read.table("./nasatea.csv", quote = "\"", sep=";", header=T, dec=".")

#On cherche a extraire uniquement les données de precipitations entre YEAR et DEC
df1<-subset(df, PARAMETER== "PRECTOTCORR", select=c(YEAR:DEC))
head(df1)

# install packages
#install.packages("readxl")
install.packages("reshape2")

# load libraries
#library(readxl)
library(reshape2)

#pas besoin de transposer 
#on met les années en première colonne
#et les mois en deuxième colonne
df1<-melt(df1, id.var="YEAR", variable.name="MONTH")
head(df1)

#on veut tous les mois de la première année (ici 1981)
#on trie les données par années puis par mois
df1<-df1[order(df1$YEAR),]
head(df1)

#on renome les lignes 
row.names(df1)<-NULL
head(df1)

#on renomme la colonne des précipitations "PRCP"
colnames(df1)[3]<-"PRCP"
colnames(df1)

#les données sont au bon format !!! ;)
head(df1)

#on fait de même pour les températutes MAX
df2<-subset(df, PARAMETER== "T2M_MAX", select=c(YEAR:DEC))
df2<-melt(df2, id.var="YEAR", variable.name="MONTH")
df2<-df2[order(df2$YEAR),]
colnames(df2)[3]<-"Tmax"
df2<-subset(df2, select = c(-YEAR, -MONTH))
head(df2)

#on fait de même pour les températures MIN
df3<-subset(df, PARAMETER== "T2M_MIN", select=c(YEAR:DEC))
df3<-melt(df3, id.var="YEAR", variable.name="MONTH")
df3<-df3[order(df3$YEAR),]
colnames(df3)[3]<-"Tmin"
df3<-subset(df3, select = c(-YEAR, -MONTH))
head(df3)

#on combine les deux vecteurs df2 et df3 avec le DF df1

df1<-cbind(df1,df2,df3)
head(df1)
# les données sont dans le bon format :) !!!!

library

df1$PET<-hargreaves(Tmin=df1$Tmin,Tmax=df1$Tmax, lat=52.164) # new column <-fonction(Tmin, Tmax, lat)


?hargreaves

WBal<-df1$PRCP-df1$PET #water balance calculation 

WBal

spei6<-spei(WBal,6)# list <- function(data, scale)

spei6
plot.spei(spei6)
