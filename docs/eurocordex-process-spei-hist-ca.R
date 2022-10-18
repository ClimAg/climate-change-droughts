# %% [markdown]
# # SPEI - Historical data - Cork Airport

# %%
# set working directory to root
setwd("../../")

# %%
# import requirements and functions
source(
    "./jupyter-notebooks/scripts/spi-spei.R",
    echo = TRUE,
    max.deparse.length = 2000
)

# %%
# Cork Airport grid cell
indexcell <- 68801

# latitude
lat <- 51.84722

# directory where the historical nc files are stored
datadir <- "./data/eurocordex/DMI/historical/mon/"

# %%
# process precipitation data
data <- hist_process(
    datadir = datadir, variable = "pr", indexcell = indexcell
)

# %%
# process tasmax data
data$tasmax <- hist_process(
    datadir = datadir, variable = "tasmax", indexcell = indexcell
)$tasmax

# %%
# process tasmin data
data$tasmin <- hist_process(
    datadir = datadir, variable = "tasmin", indexcell = indexcell
)$tasmin

# %%
head(data)

# %%
dcast(data, year~month, value.var = c("pr"))

# %%
dcast(data, year~month, value.var = c("tasmax"))

# %%
dcast(data, year~month, value.var = c("tasmin"))

# %% [markdown]
# ## SPEI-12

# %%
spei <- spei_calc(data = data, spei_num = 12, lat = lat)

# %%
# view the data
spei

# %%
plot_title <- paste(
    "SPEI-12, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spei, plot_title = plot_title)

# %% [markdown]
# ## SPEI-6

# %%
spei <- spei_calc(data = data, spei_num = 6, lat = lat)

# %%
# view the data
spei

# %%
plot_title <- paste(
    "SPEI-6, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spei, plot_title = plot_title)

# %% [markdown]
# ## SPEI-3

# %%
spei <- spei_calc(data = data, spei_num = 3, lat = lat)

# %%
# view the data
spei

# %%
plot_title <- paste(
    "SPEI-3, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spei, plot_title = plot_title)

# %% [markdown]
# ## SPEI-1

# %%
spei <- spei_calc(data = data, spei_num = 1, lat = lat)

# %%
# view the data
spei

# %%
plot_title <- paste(
    "SPEI-1, 1976-2005, Cork Airport, EURO-CORDEX data",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spei, plot_title = plot_title)

# %% [markdown]
# ## Validation
#
# Monthly historical Cork Airport data from Met Éireann: <https://www.met.ie/climate/available-data/historical-data>
#
# Direct download link:
#
# - Data from 1961 to present: <https://cli.fusio.net/cli/climate_data/webdata/mly3904.zip>

# %%
# read data
data <- readLines("./data/met/raw/meteireann/corkairport/mly3904/mly3904.csv")
# https://stackoverflow.com/a/15860268
data <- data[-1:-19]
data <- read.csv(
    textConnection(data), header = TRUE, stringsAsFactors = FALSE
)

# %%
head(data)

# %%
# filter for the past data range
data <- subset(data, year < 2006 & year > 1975)

# %%
# keep only required data
data <- subset(data, select = c(year, month, rain, maxtp, mintp))

# %%
head(data)

# %%
# rename columns
colnames(data)[3] <- "pr"
colnames(data)[4] <- "tasmax"
colnames(data)[5] <- "tasmin"

# %%
head(data)

# %%
# convert precipitation to mm/day
# https://stackoverflow.com/a/42045514
data$pr <- data$pr/days_in_month(
    paste(data$year, "-", data$month, "-15", sep = "")
)

# %%
# convert month format
data$month <- month(data$month, label = TRUE)

# %%
# sort data
data <- data[order(data$year, data$month),]

# %%
# reset row names
rownames(data) <- NULL

# %%
# convert to data table
data <- as.data.table(data)

# %%
dcast(data, year~month, value.var = c("pr"))

# %%
dcast(data, year~month, value.var = c("tasmax"))

# %%
dcast(data, year~month, value.var = c("tasmin"))

# %% [markdown]
# ### SPEI-12

# %%
spei <- spei_calc(data = data, spei_num = 12, lat = lat)

# %%
spei

# %%
plot_title <- "SPEI-12, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spei, plot_title = plot_title)

# %% [markdown]
# ### SPEI-6

# %%
spei <- spei_calc(data = data, spei_num = 6, lat = lat)

# %%
spei

# %%
plot_title <- "SPEI-6, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spei, plot_title = plot_title)

# %% [markdown]
# ### SPEI-3

# %%
spei <- spei_calc(data = data, spei_num = 3, lat = lat)

# %%
spei

# %%
plot_title <- "SPEI-3, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spei, plot_title = plot_title)

# %% [markdown]
# ### SPEI-1

# %%
spei <- spei_calc(data = data, spei_num = 1, lat = lat)

# %%
spei

# %%
plot_title <- "SPEI-1, 1976-2005, Cork Airport, Met Éireann data"

spi_plot(data = spei, plot_title = plot_title)
