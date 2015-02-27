# WeatherCheckLoad.r
 This file contains a functions to check if weather data is already available in our own MySQL database, 
 And if not it grabs the data from forecast.io and loads it into the database
 As a result there is one major function and a couple of subfunctions that could be useful on their own

## LIST OF FUNCTIONS ************************************************************************
* FIOWeatherGetHourlyAtAllCosts looks for hourly weather data in the database, and if it doesn't exist will fetch it from forecast.io
* DBWeatherGetLoc Check if a location already has an identifier, if not it creates one, and it returns the identifier
* DBWeatherGetDays Gets all daily data avaialable within time bounds. Returns which dates have data and optionally also returns the data
* FIOWeatherGrabLoad loads days of data from forecast.io and inserts them into my own personal database
* DBWeatherGetHours Gets all hourly data between time bounds. 
* psqlWriteDataFrame Loads data into PostgreSQL database: I found writing data into PG using R's database tools much more finicky that for mysql
                


# The weather_forecastio database
It is storred on switch-db2
The setup schema for the database is stored in a mysql script to be uploaded maybe. 
