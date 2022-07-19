####SPI_SPEI comparison code###

#import functions
source("functions/spi-spei.R")

# load libraries
library(data.table)
library(SPEI)

spi1data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 1)
spei1data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 1, lat = 51.847)

spi3data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 3)
spei3data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 3, lat = 51.847)

spi6data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 6)
spei6data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 6, lat = 51.847)

spi12data <- spi_process(filepath = "./data/corkair(81-10).csv", number = 12)
spei12data <- spei_process(filepath = "./data/corkair(81-10).csv", number = 12, lat = 51.847)

dfall <- subset(spi6data, select=c(YEAR, MONTH))
dfall<-cbind(dfall,
             spi1data[, ncol(spi1data), drop = FALSE], spei1data[, ncol(spei1data), drop = FALSE],
             spi3data[, ncol(spi3data), drop = FALSE], spei3data[, ncol(spei3data), drop = FALSE],
             spi6data[, ncol(spi6data), drop = FALSE], spei6data[, ncol(spei6data), drop = FALSE],
             spi12data[, ncol(spi12data), drop = FALSE], spei12data[, ncol(spei12data), drop = FALSE])
dfall

# Correlation analysis of SPI anad SPEI

as.vector(dfnew$SPI6)
as.vector(dfnew$SPEI6)

result= cor.test(as.vector(dfnew$SPI6),as.vector(dfnew$SPEI6),
         method = "pearson",
         conf.level = 0.90)
print(result)

