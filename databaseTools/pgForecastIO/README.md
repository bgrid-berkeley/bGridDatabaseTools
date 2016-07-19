# pgForecastIO.r
This file contains functions to (A) load data from the API into the database and (B) to load data from the database into R. The primary function is ``FIOWeatherGetHourlyAtAllCosts`` which checks if weather data is already available in the PostgreSQL database, and if not it grabs the data from forecast.io and loads it into the database

This is dependent on the Rforecastio library, which is installed through the devtools package. With devtools loaded, run install_github("Rforecastio","hrbrmstr") to get the current version of Rforecastio. 

To see an example of using this tool in R see [pgForecastIO_driverExample.R](pgForecastIO_driverExample.R).  


## Update
pgForecatIO_v2.R now uses the newer version of Rforecastio.  The major difference is that we no longer have to input our API keys in the files... however they do need to be stored as environment variables. 

You must create or edit a file in your home directory ~/.Renviron.  Add a line to this file: FORECASTIO_API_KEY = [your key here]

## LIST OF FUNCTIONS ************************************************************************
* ``FIOWeatherGetHourlyAtAllCosts`` looks for hourly weather data in the database, and if any data do not exist it will fetch them from forecast.io
* ``DBWeatherGetLoc`` Checks if a location already has an identifier, locID, if not it creates one and returns the identifier
* ``DBWeatherGetDays`` Gets all daily data avaialable within time bounds. Returns which dates have data and optionally also returns the data
* ``FIOWeatherGrabLoad`` loads days of data from forecast.io and inserts them into my own personal database
* ``DBWeatherGetHours`` Gets all hourly data between time bounds. 
* ``psqlWriteDataFrame`` Loads data into PostgreSQL database. I found writing data into PG using R's database tools much more finicky that for mysql
                


## The weather_forecastio database
The database storred on switch-db2
The setup schema for the database is stored in a mysql script to be uploaded maybe. 
I will describe the schema later, you can look at it now in pgAdmin. 

## Detailed description of functions 

### ``FIOWeatherGetHourlyAtAllCosts``
#### Objective
Return hourly weather data for a desired time period and location. If data have not already been downloaded from Forecast.io and stored in the weather_forecastio database the program will do so.


#### Inputs (in order): 

* ``latitude``   (numeric) latitude of the location for which data is to be pulled 
 					(current precision is set to .001 decimal degrees and should be loosened)
* ``longitude``  (numeric) longitude of the location
* ``timebounds`` (POSIXct) two element vector defining first and final dates to be pulled, all dates between will also be pulled
* ``dbcon``      (PostgreSQL connection) an example of how to generation such a connection is in pgForecastIO_DriverExample.R
* ``apikey``     (character) api key for forecastio as a character string
* ``verbose``    (logical) default = FALSE, set to TRUE if you want to be messaged regarding API calls

#### Output (dataframe)
dataframe of all hourly weather information returned by the Forecast.io API. 

#### Description of process
1. Use ``DBWeatherGetLoc`` to check if the location exists in the pg database, if not it creates a location record. 
2. Use ``DBWeatherGetDays`` to check days in the desired time period have already been downloaded from Forecast.io and loaded to the database. 
3. Use ``FIOWeatherGrabLoad`` to download any missing days from the API and load them into the pg database tables.
4. Use ``DBWeatherGetHours`` to pull the entirity of data requested from the pg database. 
*

### ``DBWeatherGetLoc`` 
#### Objective 
Checks if a location already has an identifier, locID, if not it creates one and returns the identifier

#### Inputs (in order): 

* ``latitude``   (numeric) latitude of the location for which data is to be pulled 
 					(current precision is set to .001 decimal degrees and should be loosened)
* ``longitude``  (numeric) longitude of the location
* ``dbcon``      (PostgreSQL connection) an example of how to generation such a connection is in pgForecastIO_DriverExample.R

#### Outputs (numeric)
the location identifier, locId, of the location. 

### ``DBWeatherGetDays`` 
#### Objective 
Gets all daily data avaialable within time bounds. Returns which dates have data and optionally also returns the data

#### Inputs (in order): 

* ``locId``      (numeric) location identifier for the desired lat/long in the pgDatabase, returned by ``DBWeatherGetLoc``
* ``timebounds`` (POSIXct) two element vector defining first and final dates to be pulled, all dates between will also be pulled
* ``dbcon``      (PostgreSQL connection) an example of how to generation such a connection is in pgForecastIO_DriverExample.R
* ``returndata`` (logical) default = TRUE, whether or not to actually return daily data or to just check which dates exist. 

#### Output (list)
outputs a list with three names elements
* ``datesToLoad`` list of requested dates which need to be downloaded from the forecast.io API
* ``datesWithData`` list of requested dates which already exist in the pg database
* ``dailyData`` actualy daily data (only if requested)

### ``FIOWeatherGrabLoad`` 
#### Objective 
DO NOT USE DIRECTLY!  To prevent duplicate entries, only load data through the  ``FIOWeatherGetHourlyAtAllCosts`` function

This function downloads days of data (hourly and daily) from the forecast.io API and inserts them into the pg database. 

#### Inputs (in order): 

* ``latitude``   (numeric) latitude of the location for which data is to be pulled 
 					(current precision is set to .001 decimal degrees and should be loosened)
* ``longitude``  (numeric) longitude of the location
* ``dates``      (POSIXct) vector of dates to be loaded from 
* ``dbcon``      (PostgreSQL connection) an example of how to generation such a connection is in pgForecastIO_DriverExample.R
* ``apikey``     (character) api key for forecastio as a character string

#### Outputs (null)
There are no outputs

### ``DBWeatherGetHours`` 
#### Objective 
Gets all hourly data between time bounds from the pg database. 

#### Inputs (in order): 

* ``locId``      (numeric) location identifier for the desired lat/long in the pgDatabase, returned by ``DBWeatherGetLoc``
* ``timebounds`` (POSIXct) two element vector defining first and final dates to be pulled, all dates between will also be pulled
* ``dbcon``      (PostgreSQL connection) an example of how to generation such a connection is in pgForecastIO_DriverExample.R

#### Output (dataframe)
dataframe of all hourly weather information returned by the Forecast.io API. 


### ``psqlWriteDataFrame`` 
#### Objective 
Loads data into PostgreSQL database. I found writing data into PG using R's database tools much more finickey than for mysql and had to write my own function. 

More documentation to come later, this may end up being generally useful to connecting pg databases with R.  
