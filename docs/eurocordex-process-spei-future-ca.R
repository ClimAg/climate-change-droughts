# %% [markdown]
# # SPEI - Future data - Cork Airport

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

# directory where the future nc files are stored
datadir <- "./data/eurocordex/DMI/rcp85/mon/"

# %%
# process precipitation data
data <- future_process(
    datadir = datadir, variable = "pr", indexcell = indexcell
)

# %%
# process tasmax data
data$tasmax <- future_process(
    datadir = datadir, variable = "tasmax", indexcell = indexcell
)$tasmax

# %%
# process tasmin data
data$tasmin <- future_process(
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
    "SPEI-12, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
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
    "SPEI-6, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
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
    "SPEI-3, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
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
    "SPEI-1, 2041-2070, Cork Airport, EURO-CORDEX data, RCP8.5",
    "[EUR-11, NCC-NorESM1-M, r1i1p1, DMI-HIRHAM5, v3]",
    sep = "\n"
)

spi_plot(data = spei, plot_title = plot_title)
