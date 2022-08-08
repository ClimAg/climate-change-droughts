source("functions/convert-units.R")

ec_process <- function (datapath, indexcell, var) {
  df <- nc_grid_to_dt(filename = datapath, variable = var)
  #choose a specific index cell
  df1<-subset(df, icell==indexcell)
  #define the date in a date format
  df1$date <- as.Date(df1$date, format = "%Y-%m-%d")
  #add columns month and year
  df1$month <- month(df1$date)


  df1$year <-year(df1$date)
  if (var=="pr"){
    # df1[, var] <- kgm2s(df1[, var])#convert the precipitation units from kgm2s to mm/day
    # df1$kgm2s <- df1$pr
      df1$pr <- kgm2s(df1$pr)
  }
  else if (var=="tasmax"){
      df1$tasmax<- kelvin_to_celsuis(df1$tasmax)#convert the temperature units from kelvin to celsuis
  }
  else if (var=="tasmin"){
      df1$tasmin<- kelvin_to_celsuis(df1$tasmin)#convert the temperature units from kelvin to celsuis
  }
  return (df1)
}
