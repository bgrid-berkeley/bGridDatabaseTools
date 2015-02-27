require(RPostgreSQL)
require(Rforecastio)
source('path/to/bGridDatabaseTools/pgForecastIO/pgForecastIO.R')

drv <- dbDriver("PostgreSQL")

apikey   <- readLines('path/to/your/secret/apikeyfor/forecastio')[1]
psqlpass <- readLines('path/to/your/secret/password/for/PostgreSQL')[1]

## Connect to the consert database
wcon <- dbConnect(drv, user ="uname", pass = psqlpass, dbname="weather_forecastio", host="switch-db2.erg.berkeley.edu", port=5432)

## get some data
tbounds = as.POSIXct(c("2011-12-01 00:00:00" ,"2011-12-03 17:45:00"), tz = 'America/Regina')

lat <- 37
lon <- -114

weatherdata <- FIOWeatherGetHourlyAtAllCosts(latitude = lat, longitude = lon, 
                                               timebounds = tbounds, dbcon = wcon,
                                               apikey = apikey, verbose = TRUE)
