## Load required libraries and source the file with the database functions
require(RPostgreSQL)
require(Rforecastio)
source('path/to/bGridDatabaseTools/pgForecastIO/pgForecastIO.R')

## Setup the postgresql driver
drv <- dbDriver("PostgreSQL")

## Load your api keys and passwords
apikey   <- readLines('path/to/your/secret/apikeyfor/forecastio')[1]
psqlpass <- readLines('path/to/your/secret/password/for/PostgreSQL')[1]

## Connect to the weather database
wcon <- dbConnect(drv, user ="uname", pass = psqlpass, dbname="bgrid", host="switch-db2.erg.berkeley.edu", port=5432)

## Modify our database environment to include our weather schema

dbGetQuery(wcon,'SET search_path = weather_forecastio, public;') # Sets the order in which we search schemas. Only valid for the current session.

###  Example using single latitude and longitude ********************************************

# # Set time bounds within which to collect data
# # Notes: Forecast.io returns a full day of historical data
# #        The call to Forecast.io is in local time, but will ultimately be save to the DB in UTC.
# tbounds = as.POSIXct(c("2011-12-01 00:00:00" ,"2011-12-03 17:45:00"), tz = 'America/Los_Angeles')
# 
# # set latitude and longitude
# lat <- 37.87 # UC Berkeley is 37.87, -122.26
# lon <- -122.26  
# 
# # Get data at all costs!
# weatherdata <- FIOWeatherGetDataAtAllCosts(latitude = lat, longitude = lon, 
#                                                timebounds = tbounds, dbcon = wcon,
#                                                apikey = apikey, verbose = TRUE)

## Example using a list of datapoints from a CSV *******************************************
# for each node in our list
#  If our counter is below the limit, execute the call
#  If not, wait until midnight then   execute the call

dailyCalls = 10 # The bgrid Forecast.io call limit is 100K calls/day.  This equates to ~300 point-years of data. 

myPoints = read.csv("LMPLocations.csv") # needs to include a column called 'latitude' and a column called 'longitude'

tbounds = as.POSIXct(c("2013-01-05 00:00:00" ,"2013-01-05 00:00:00"), tz = 'America/Los_Angeles')

callCount = 0 # this will be our counter to make sure that we're below our API cap for the day

#i = 1 # uncomment this to just work with one location

for (i in nrow(myPoints)){  # could also use an apply function, but would be less readable

  if (callCount >= dailyCalls){
    # We've hit our call count; wait until midnight and then go ahead
    print("Call limit reached; sleeping until midnight")
    secsTillMidnight <- as.double(24 - (Sys.time() - as.POSIXct(trunc(Sys.time(),units="days") ) ) )  #Awkward, but this works... times in R are a headache
    Sys.sleep(secsTillMidnight)
    callCount = 0
  }
  
    newCalls = FIOWeatherGetDataAtAllCosts(latitude = myPoints[i,'latitude'], longitude = myPoints[i,'longitude'], timebounds = tbounds, dbcon =wcon, apikey = apikey, verbose = TRUE, callCount = TRUE)[1]
    print(paste("Processed node ",myPoints[i,'name']))
    callCount = callCount + length(newCalls$callCount)

} # comment this to just work with one location
