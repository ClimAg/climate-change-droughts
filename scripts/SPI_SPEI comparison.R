####SPI_SPEI comparison code###

#import functions
source("functions/spi-spei.R")

# load libraries
library(data.table)
library(SPEI)


spi6data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 6)
spei6data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 6, lat = 51.847)

spi12data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 12)
spei12data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 12, lat = 51.847)

dfall <- subset(spi6data, select=c(YEAR, MONTH))

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

library(stringr)
maj<-c("spi")
maj %>% str_to_upper()
