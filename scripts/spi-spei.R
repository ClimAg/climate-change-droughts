library(eurocordexr)
library(SPEI)
library(latticeExtra)
library(lubridate)

# unit conversion functions
kelvin_to_celsius <- function(kelvin) {
  celsius <- (kelvin - 273.15)
  return(celsius)
}

kgm2s_to_mmday <- function(kgm2s) {
  mmday <- (kgm2s * 60 * 60 * 24)
  return(mmday)
}

# function to extract EURO-CORDEX data from the nc files
ec_process <- function(datapath, indexcell, var) {
    df <- nc_grid_to_dt(filename = datapath, variable = var)

    # subset data for an icell
    df <- subset(df, icell == indexcell)

    # convert the date format
    df$date <- as.Date(df$date, format = "%Y-%m-%d")

    # extract month and year columns
    df$month <- month(df$date, label = TRUE)
    df$year <- year(df$date)

    # convert units
    if (var == "pr") {
        df$pr <- kgm2s_to_mmday(df$pr)
    }
    else if (var == "tasmax") {
        df$tasmax <- kelvin_to_celsius(df$tasmax)
    }
    else if (var == "tasmin") {
        df$tasmin<- kelvin_to_celsius(df$tasmin)
    }

    return (df)
}

# function to process historical EURO-CORDEX NetCDF files
hist_process <- function(datadir, variable, indexcell) {
    # nc file path
    ncfile <- paste(
        datadir,
        variable,
        "_EUR-11_NCC-NorESM1-M_historical_r1i1p1_DMI-HIRHAM5_v3_mon_",
        sep = ""
    )

    # process each nc file for the historical period for the given variable
    d1 <- ec_process(
        datapath = paste(ncfile, "197101-198012.nc", sep = ""),
        indexcell = indexcell,
        var = variable
    )

    d2 <- ec_process(
        datapath = paste(ncfile, "198101-199012.nc", sep = ""),
        indexcell = indexcell,
        var = variable
    )

    d3 <- ec_process(
        datapath = paste(ncfile, "199101-200012.nc", sep = ""),
        indexcell = indexcell,
        var = variable
    )

    d4 <- ec_process(
        datapath = paste(ncfile, "200101-200512.nc", sep = ""),
        indexcell = indexcell,
        var = variable
    )

    # combine the historical data
    d_hist <- rbind(d1, d2, d3, d4)

    # subset for the reference period
    d_hist <- subset(d_hist, year > 1975)

    # drop unnecessary columns
    d_hist <- subset(d_hist, select = c(-icell, -date))

    # sort data
    d_hist <- d_hist[order(d_hist$year, d_hist$month),]

    # reset row names
    rownames(d_hist) <- NULL

    return(d_hist)
}

# function to process future EURO-CORDEX NetCDF files
future_process <- function(datadir, variable, indexcell) {
    # nc file path
    ncfile <- paste(
        datadir,
        variable,
        "_EUR-11_NCC-NorESM1-M_rcp85_r1i1p1_DMI-HIRHAM5_v3_mon_",
        sep = ""
    )

    # process each nc file for the historical period for the given variable
    d1 <- ec_process(
        datapath = paste(ncfile, "204101-205012.nc", sep = ""),
        indexcell = indexcell,
        var = variable
    )

    d2 <- ec_process(
        datapath = paste(ncfile, "205101-206012.nc", sep = ""),
        indexcell = indexcell,
        var = variable
    )

    d3 <- ec_process(
        datapath = paste(ncfile, "206101-207012.nc", sep = ""),
        indexcell = indexcell,
        var = variable
    )

    # combine the data
    d_future <- rbind(d1, d2, d3)

    # drop unnecessary columns
    d_future <- subset(d_future, select = c(-icell, -date))

    # sort data
    d_future <- d_future[order(d_future$year, d_future$month),]

    # reset row names
    rownames(d_future) <- NULL

    return(d_future)
}

# function to calculate SPI
spi_calc <- function(
    data,
    spi_num,
    kernel = list(type = "rectangular", shift = 0),
    distribution = "Gamma",
    fit = "ub-pwm"
) {
    # calculate SPI for the data
    spi <- spi(
        data$pr,
        spi_num,
        kernel = kernel,
        distribution = distribution,
        fit = fit
    )

    # convert the time series to a data table and add it to the main data table
    data$spi <- as.data.table(spi$fitted)

    # subset only the month, year, and SPI data to another data table
    spi <- subset(data, select = c(-pr))

    # reshape the data
    spi <- dcast(spi, year~month, value.var = c("spi"))

    # use year as the row name
    spi <- data.frame(spi)
    row.names(spi) <- spi$year
    spi[, "year"] <- NULL

    return (spi)
}

# function to calculate SPEI
spei_calc <- function(
    data,
    spei_num,
    lat,
    kernel = list(type = "rectangular", shift = 0),
    distribution = "log-Logistic",
    fit = "ub-pwm"
) {
    # potential evapotranspiration
    data$pet <- hargreaves(Tmin = data$tasmin, Tmax = data$tasmax, lat = lat)

    # water balance
    data$wbal <- data$pr - data$pet

    # calculate SPEI for the data
    spei <- spei(
        data$wbal,
        spei_num,
        kernel = kernel,
        distribution = distribution,
        fit = fit
    )

    # convert the time series to a data table and add it to the main data table
    data$spei <- as.data.table(spei$fitted)

    # subset only the month, year, and SPEI data to another data table
    spei <- subset(data, select = c(-pr))

    # reshape the data
    spei <- dcast(spei, year~month, value.var = c("spei"))

    # use year as the row name
    spei <- data.frame(spei)
    row.names(spei) <- spei$year
    spei[, "year"] <- NULL

    return (spei)
}

# function to plot SPI as a lattice plot
spi_plot <- function(data, plot_title) {
    # set plot resolution
    options(repr.plot.res = 200)

    # create SPI color palette
    palette_spi <- palette(c(
        "red", "orange", "yellow", "white", "#D2B4DE", "#8E44AD", "#4A235A"
    ))

    # create a theme using the palette, and assign custom fonts
    spiTheme <- modifyList(
        custom.theme(region = palette_spi),
        list(
            panel.background = list(col = "black"),
            axis.text = list(fontfamily="Source Sans 3"),
            par.xlab.text = list(fontfamily="Source Sans 3"),
            par.ylab.text = list(fontfamily="Source Sans 3"),
            par.main.text = list(fontfamily="Source Sans 3"),
            par.sub.text = list(fontfamily="Source Sans 3")
        )
    )

    # manually assign breaks corresponding to SPI ranges
    # https://stackoverflow.com/a/47464897
    breaks <- c(-5, -2, -1.5, -1, 1, 1.5, 2, 5)
    colorkeyBreaks <- seq(-5, 5, by = 10/7)
    colorkey <- list(
        at = colorkeyBreaks,
        labels = list(at = colorkeyBreaks, labels = breaks),
        space = "bottom"
    )

    # plot the SPI matrix
    levelplot(
        as.matrix(data),
        col.regions = palette_spi,
        at = breaks,
        colorkey = colorkey,
        xlab = list(label = "Year"),
        ylab = list(label = "Month"),
        scales = list(x = list(rot = 90)),
        main = list(label = plot_title, cex = 1.5),
        par.settings = spiTheme,
        margin = FALSE
    )
}
