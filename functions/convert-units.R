#convert Kelvin to degrees Celsius


# function that converts temperature in kelvin to degrees Fahrenheit
  # input: kelvin: numeric value representing temp in kelvin
  # output: degrees celsius: numeric converted temp in degrees Celsius
kelvin_to_celsuis <- function(kelvin) {
  celsuis <- (kelvin - 273.15)
  return(celsuis)
}
kelvin_to_celsuis(298)

#convert kgm2s to degrees mmday


# function that converts precipiation in kgm2s to degrees mmday
# input: kgm2s: numeric value representing temp in kgm2s
# output: mmday: numeric converted temp in mmday

kgm2s<-function(kgm2s){
  mmday<-(kgm2s*86400)
  return(mmday)
}

kgm2s(289)
