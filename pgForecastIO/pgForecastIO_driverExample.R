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

myPoints = read.csv("LMPLocations.csv") # needs to include a column called 'latitude' and a column called 'longitude'

tbounds = as.POSIXct(c("2013-03-05 00:00:00" ,"2013-03-15 00:00:00"), tz = 'America/Los_Angeles')

callCount = 0 # this will be our counter to make sure that we're below our API cap for the day
callCountDate = Sys.Date()
dailyCalls = 100000 # The bgrid Forecast.io call limit is 100K calls/day.  This equates to ~300 point-years of data.
                    # Note that the throttling structure below will only check once per node, _after_ calling FIOWeatherGetDataAtAllCosts. 
                    #  This means that we may be over the call limit by the number of days spanned by the timebounds. 
                    #  Could redesign to fcheck before executing, but this would require first checking the availability of
                    #  dates in the pgsql database, and is probably not worth it for the number of calls which are 
                    #  expected and the lack of a hard limit (3 years ~= 1k calls)

for (i in 1:nrow(myPoints)){  # could also use an apply function, but would be less usable
  if (Sys.Date()!=callCountDate){
    # If our bandwidth limits us to less than the call cap, we naturally roll into the next day. Reset limits.
    callCount = 0
    callCountDate = Sys.Date()
  }
  
  if (callCount < dailyCalls){
    newCalls = FIOWeatherGetDataAtAllCosts(latitude = myPoints[i,'latitude'], longitude = myPoints[i,'longitude'], timebounds = tbounds, dbcon =wcon, apikey = apikey, verbose = TRUE, callCount = TRUE)
    print(paste("Processed node ",myPoints[i,'name']))
    callCount = callCount + newCalls$callCount
    
  }else{
    # We've hit our call count; wait until midnight and then go ahead
    print("Call limit reached; sleeping until midnight")
    secsTillMidnight <- as.double(24 - (Sys.time() - as.POSIXct(trunc(Sys.time(),units="days") ) ) )  #Awkward, but this works... times in R are a headache
    Sys.sleep(secsTillMidnight)
    callCount = 0
    callCountDate = Sys.Date()
    
    newCalls = FIOWeatherGetDataAtAllCosts(latitude = myPoints[i,'latitude'], longitude = myPoints[i,'longitude'], timebounds = tbounds, dbcon =wcon, apikey = apikey, verbose = TRUE, callCount = TRUE)
    print(paste("Processed node ",myPoints[i,'name']))
    callCount = callCount + newCalls$callCount
  }
}