##SPI and SPEI functions##

# functions that calculate spi and spei values from data set (Met Irland)


# input : data (indicate the file path were the data are store), the interest period accumulation
# output: data table with 4 columns (Year, Month, Prcp, SPI values)

spi_process <- function(filepath, number) {
  spi_df <- read.table(filepath, quote = "\"", sep=";", header=T, dec=".")
  # subset year of data (1981-2010)
  spi_df <- subset(spi_df, YEAR > 1980 & YEAR < 2011)
  spi_ts <- spi(spi_df$PRCP, number)
  spi_ts <- (as.data.table(spi_ts$fitted))
  colnames(spi_ts)[1] <- gsub(" ", "", paste("SPI", as.character(number)))
  spi_df <- cbind(spi_df, spi_ts[, 1])
  rownames(spi_df) <- NULL
  return(spi_df)
}

# input : data (indicate the file path were the data are store), the interest period accumulation, the latitude of the place
# output: data table with 7 columns (Year, Month, Prcp, Tmin, Tmax, PET, SPEI values)

spei_process <- function(filepath, number, lat) {
  spei_df <- read.table(filepath, quote = "\"", sep=";", header=T, dec=".")
  # subset year of data (1981-2010)
  spei_df <- subset(spei_df, YEAR > 1980 & YEAR < 2011)
  spei_df$PET<-hargreaves(Tmin=spei_df$TMIN,Tmax=spei_df$TMAX, lat = lat)
  WBal<-spei_df$PRCP-spei_df$PET
  spei_ts <- spei(WBal, number)
  spei_ts <- (as.data.table(spei_ts$fitted))
  colnames(spei_ts)[1] <- gsub(" ", "", paste("SPEI", as.character(number)))
  spei_df <- cbind(spei_df, spei_ts[, 1])
  rownames(spei_df) <- NULL
  return(spei_df)
}

