require(RPostgreSQL)
require(Rforecastio)
source('~/Dropbox/Projects/bGridDatabaseTools/pgForecastIO/pgForecastIO.R')

drv <- dbDriver("PostgreSQL")

apikey   <- readLines('~/.apikey/forecast.io.txt')[1]
psqlpass <- readLines('~/.pass/psqlpass.txt')[1]

## Connect to the consert database
wcon <- dbConnect(drv, user ="mtabone", pass = psqlpass, dbname="weather_forecastio", host="switch-db2.erg.berkeley.edu", port=5432)

## get some data
tbounds = as.POSIXct(c("2011-12-11 00:00:00" ,"2012-03-15 17:45:00"), tz = 'America/Regina')

lat <- 36
lon <- -119

weatherdata <- FIOWeatherGetHourlyAtAllCosts(latitude = lat, longitude = lon, 
                                               timebounds = tbounds, dbcon = wcon,
                                               apikey = apikey, verbose = TRUE)
