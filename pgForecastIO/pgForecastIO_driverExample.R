## Load required libraries and source the file with the database functions
require(RPostgreSQL)
require(Rforecastio)
source('path/to/bGridDatabaseTools/pgForecastIO/pgForecastIO.R')

## Setup thee postgresql driver
drv <- dbDriver("PostgreSQL")

## Load your api keys and passwords
apikey   <- readLines('path/to/your/secret/apikeyfor/forecastio')[1]
psqlpass <- readLines('path/to/your/secret/password/for/PostgreSQL')[1]

## Connect to the weather database
wcon <- dbConnect(drv, user ="uname", pass = psqlpass, dbname="weather_forecastio", host="switch-db2.erg.berkeley.edu", port=5432)

## Get some data
# Set time bounds within which to collect data
tbounds = as.POSIXct(c("2011-12-01 00:00:00" ,"2011-12-03 17:45:00"), tz = 'America/Regina')

# set latitude and longitude
lat <- 37
lon <- -111

# Get data at all costs!
weatherdata <- FIOWeatherGetHourlyAtAllCosts(latitude = lat, longitude = lon, 
                                               timebounds = tbounds, dbcon = wcon,
                                               apikey = apikey, verbose = TRUE)
