
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
    df1$var <- kgm2s(df1$var)#convert the precipitation units from kgm2s to mm/day
  } else {
    df1$var <- kelvin_to_celsuis(df1$var)#convert the temperature units from kelvin to celsuis
  }
  return (df1)
}


