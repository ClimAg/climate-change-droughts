setwd("D:/evakl/Bureau/Moore park essais/")
df <- read.table("./nasatea.csv", quote = "\"", sep=";", header=T, dec=".")

#On cherche a extraire uniquement les données de precipitations entre YEAR et DEC
df1<-subset(df, PARAMETER== "PRECTOTCORR", select=c(YEAR:DEC))
head(df1)



install.packages("reshape2") # install package reshape2
library(reshape2) #load package reshape2


#install.packages("readxl")
#library(readxl)


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
head(df1)

#les données sont au bon format !!! ;)


install.packages ("SPEI") #install package SPEI
library(SPEI) #loading package SPEI


spi6<-spi(df1$PRCP,6) # list <-function(data,scale)


spi6
str(spi6)

plot(spi6)

#on télécharge le nv jeu de données sur pc
getwd()
write.csv(df1, file="./output.csv")