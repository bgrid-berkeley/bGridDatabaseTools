## WeatherCheckLoad.r
# This file contains a functions to check if weather data is already available in our own MySQL database, 
# And if not it grabs the data from forecast.io and loads it into the database
# As a result there is one major function and a couple of subfunctions that could be useful on their own

## LIST OF FUNCTIONS ************************************************************************
# FIOWeatherGetHourlyAtAllCosts looks for hourly weather data in the database, and if it doesn't exist will fetch it from forecast.io
# DBWeatherGetLoc Check if a location already has an identifier, if not it creates one, and it returns the identifier
# DBWeatherGetDays Gets all daily data avaialable within time bounds. Returns which dates have data and optionally also returns the data
# FIOWeatherGrabLoad loads days of data from forecast.io and inserts them into my own personal database
# DBWeatherGetHours Gets all hourly data between time bounds. 
# psqlWriteDataFrame Loads data into PostgreSQL database: I found writing data into PG using R's database tools much more finicky that for mysql
                


## The database is names weatherForecastIO
## It is storred on my local computer, 
## The schema for the database is stored in ... GeneralModelFitting/Weather_DB_Create.sql
## DONT RUN IT! IT WILL ELIMINATE THE DATABSE

library(Rforecastio)

##*** FIOWeatherGetHourlyAtAllCosts *********************************************************
FIOWeatherGetHourlyAtAllCosts <- function(latitude, longitude, timebounds, dbcon, apikey ) {
  
  ## Connect to database and set timezone
  con <- dbcon
  dbGetQuery(con,'SET time zone  "+00:00";')
  
  # Get the location id for this latitude and longitude
  locId      <- DBWeatherGetLoc(latitude = latitude, longitude = longitude, dbcon = con)
  
  # Check which dats are already loaded in the MySQL database
  daysCheck  <- DBWeatherGetDays(locId, timebounds = timebounds, returndata = F, dbcon = con)
  
  # Load any missing data from forecast.io into the database
  if (length (daysCheck$datesToLoad) > 0){
    loadCheck  <- FIOWeatherGrabLoad(latitude = latitude, longitude = longitude, locId = locId,
                                     dates = daysCheck$datesToLoad, dbcon = con, apikey = apikey)
  }
  
  # Load the hourly data from MySQL
  hourlydf   <- DBWeatherGetHours(locId = locId, timebounds = timebounds, dbcon = con )
  
  
  # Retuen the horuly dataframe
  return(hourlydf)
}

##*** FIOWeatherGetHourlyAtAllCosts *********************************************************
FIOWeatherGetDailyAtAllCosts <- function(latitude, longitude, timebounds, dbcon = NULL) {
  
  ## Connect to database and set timezone
  con <- dbcon
  dbGetQuery(con,'SET time zone  "+00:00";')
  
  
  
  # Get the location id for this latitude and longitude
  locId      <- DBWeatherGetLoc(latitude = latitude, longitude = longitude, dbcon = con)
  
  # Check which days are already loaded in the MySQL database
  daysCheck  <- DBWeatherGetDays(locId, timebounds = timebounds, returndata = F, dbcon = con)
  
  # Load any missing data from forecast.io into the database
  if (length (daysCheck$datesToLoad) > 0){
    loadCheck  <- FIOWeatherGrabLoad(latitude = latitude, longitude = longitude, locId = locId,
                                     dates = daysCheck$datesToLoad, dbcon = con)
  }
  
  # Load the hourly data from MySQL
  dailydf   <- DBWeatherGetDays(locId = locId, timebounds = timebounds, dbcon = con )
  
  
  # Retuen the horuly dataframe
  return(dailydf)
}

##*** DBWeatherGetLoc ***********************************************************************
DBWeatherGetLoc <- function(latitude, longitude, dbcon){
  ## Function to retreive the location ID of a set of latitude and longitudes 
  
  
  ## Connect to database 
  con <- dbcon
  
  ## Query the location ID, using latlong resolution of .001 (really small I know)
  locid_query <- paste('select locId from locations WHERE ABS(latitude - ',latitude, ') < .001 AND ',
                       ' ABS(longitude - ',longitude,') < .001')
  locId       <- dbGetQuery(con, locid_query)[1,1] 
  
  ## If locatino ID doesn't exist create a new location
  if (is.null(locId)){
    # Get timing of entry 
    nowtime <- Sys.time()
    attr(time, 'tzone') <- 'UTC'
    
    # auto increment the id manually (damnit psql)
    locId       <- dbGetQuery(con, 'SELECT max(locid) from locations;')[1,1] +1
    
    #  Make the input data
    locmeta                <- data.frame(matrix(nrow = 1, ncol = 0))
    locmeta$locId          <- locId
    locmeta$latitude       <- latitude
    locmeta$longitude      <- longitude
    locmeta$dateCreated    <- nowtime
    
    ## Load locatinoal metadata into mysql 
    dbWriteTable( 
      con, 
      "locations", 
      value=locmeta, 
      append=TRUE, 
      row.names=FALSE #, 
      #field.types=field.types 
    ) 
    
  }
  
  
  return(locId)
}

##*** DBWeatherGetDays ***********************************************************************
DBWeatherGetDays <- function(locId, timebounds, dbcon, returndata = TRUE){
  ## Function to grab already stored days of weather data for a set of times and a location
  # Given a set of time bounds
  # Inputs a location ID (can be received by FIOWeatherGetLoc)
  # Outputs a dataset of dayly data and a vector of days for which data eneed to be loaded
  
  ## connect to database 
  con <- dbcon
  dbGetQuery(con,'SET time zone  "+00:00";')
  
  
  ## Construct dates to return, all times should be in local standard time 
  dates <- seq(from = timebounds[1], to = timebounds[2], by = 24 * 3600)
  dates <- round(dates,'days')
  
  ## Grab the days for this location 
  msqldatestr <- paste("\'",dates,"\'", collapse=",", sep = "")
  
  if (returndata) {
    msqlquery   <- paste('SELECT * from "dailyData" WHERE "locId" = ',locId,'AND "dateMeasurement" IN (', msqldatestr,');')
  } else {
    msqlquery   <- paste('SELECT "dateMeasurement" from "dailyData" WHERE "locId" = ',locId,'AND "dateMeasurement" IN (', msqldatestr,');')
  }
  
  ## Get the daily data
  dailyData <- dbGetQuery(con, msqlquery)
  
  ## dates2 
  datesNeeded  <- as.Date(dates)
  
  ## return a list of days for which data are needed
  if ( dim(dailyData)[1] > 0) {
    datesToLoad   <- dates[!is.element(datesNeeded,dailyData$dateMeasurement)]
    datesWithData <- dates[is.element(datesNeeded,dailyData$dateMeasurement)]
  } else {
    datesToLoad   <- dates
    datesWithData <- c()
  }
  
  ## return
  out <- list()
  out$datesToLoad   <- datesToLoad
  out$datesWithData <- datesWithData
  if (returndata) out$dailyData <- dailyData
  return(out)
}

##*** FIOWeatherGrabLoad ***********************************************************************
FIOWeatherGrabLoad <- function(latitude, longitude, dates, locId = NA, dbcon, apikey = NA){
  # This function is created to load days of data from forecast.io and insert them into my own personal database
  # Inputs are 
  # latitude  : latitude of forecast.io location
  # longitude : longitude of locatoin
  # dates     : dates to load from forecast.io (gives 24 hourls in local time)
  # locID     : the location id of the locatoin in the dataset, if not know the function will retreive it
  # dbcon     : RBySQL connectin to the database, in not supplies a new connection is made
  
  
  ## connect to database
  con <- dbcon
  dbGetQuery(con,'SET time zone  "+00:00";')
  
  ## get time zone of database
  #tzdb <- dbGetQuery(con,'SET time_zone = "+00:00";')
  
  
  # get needed information
  if (is.na(apikey))  stop('API key required')
  UNIXtime  <- as.numeric(dates) 
  
  ## Get the locid from the locations metadata table
  if (is.na(locId)){
    locId <- DBWeatherGetLoc(latitude, longitude, dbcon = con)[1]
  }
  
  for (d in 1 : length(dates)){    
    
    # get the data
    fio.list <- fio.forecast(apikey, latitude = latitude, longitude = longitude, for.time = UNIXtime[d], time.formatter = as.POSIXct )
    
    ## Create daily data for this pull 
    newcols <- data.frame( 'locId' = locId, 'dateCreated' = nowtime  , 'dateMeasurement' = round(dates[d], 'days'))
    ncol    <- dim(fio.list$daily.df)[2]
    daily.in <- cbind(newcols, fio.list$daily.df[,c(2,4:ncol)])
    
    ## put daily.in times into the MySQLs timexone
    attr(daily.in$dateCreated,     'tzone') <- 'UTC'
    attr(daily.in$dateMeasurement, 'tzone') <- 'UTC'
    
    # create dayId column (required for the psql R connection :()
    dayId <- as.numeric(dbGetQuery(wcon, 'SELECT max("dayId") from "dailyData";')+1)
    daily.in <- cbind(dayId, daily.in)
    colnames(daily.in)[1] <- 'dayId'
    
    # rearrange columns to match those is psql (some of them got swapped in the transfer somehow)
    lfields             <- dbListFields(wcon,'dailyData')
    idmatch             <- match(colnames(daily.in), lfields)
    daily.in2           <- data.frame(matrix(NA, nrow = 1, ncol = length(lfields)))
    colnames(daily.in2) <- lfields
    daily.in2[,idmatch] <- daily.in[,]
    
    ## Load daily data into MySQL 
    dbWriteTable( 
      con, 
      "dailyData", 
      value=daily.in2, 
      overwrite=FALSE, 
      append=TRUE, 
      row.names=FALSE #, 
      #field.types=field.types     
    )
    
    ## Create Hourly Data for this pull 
    hoursUTC <- fio.list$hourly.df$time
    attr(hoursUTC, 'tzone') <- 'UTC'
    
    newcolshourly <- data.frame( 'locId' = matrix(locId[1], nrow= 24), 
                                 'dayId' = matrix(dayId[1], nrow= 24), 
                                 'dateTime' = hoursUTC )
    ncol    <- dim(fio.list$hourly.df)[2]
    hourly.in <- cbind(newcolshourly, fio.list$hourly.df[,c(4:ncol)])
    
  
    ## Load hourly data into MySQL 
    psqlWriteDataFrame( 
      con = con, 
      tablename = "hourlyData", 
      value=hourly.in
      #field.types=field.types 
      
    )
  }
  
}

##*** DBWeatherGetHours ***********************************************************************
DBWeatherGetHours <- function(locId, timebounds, dbcon){
  ## Function to grab already stored days of weather data for a set of times and a location
  # Given a set of time bounds
  # Inputs a location ID (can be received by FIOWeatherGetLoc)
  # Outputs a dataset of dayly data and a vector of days for which data eneed to be loaded
  
  ## connect to database
  con <- dbcon
  
  
  ## Construct dates to return, all times should be in local standard time 
  dates <- seq(from = timebounds[1], to = timebounds[2], by = 24 * 3600)
  dates <- round(dates,'days')
  
  ## Grab the dayIDs for this call 
  msqldatestr <- paste("\'",dates,"\'", collapse=",", sep = "")
  Dmsqlquery   <- paste('SELECT "dayId" FROM "dailyData" WHERE "locId" = ',
                        locId,'AND "dateMeasurement" IN (', msqldatestr,');')
  
  ## Get the daily data
  dailyData <- dbGetQuery(con, Dmsqlquery)
  
  ## Construct a query to load hourly data
  dayidstr   <- paste( dailyData$dayId, collapse = "," )
  hquery     <- paste( 'SELECT *, extract(epoch from "dateTime" at time zone \'utc\')',
                       ' FROM "hourlyData" WHERE "dayId" in (', dayidstr  ,');' )
  
  
  ## get the hourly data
  hourlyData <- dbGetQuery(con, hquery)
  unixcol    <- grep('date_part', colnames(hourlyData))
  hourlyData$dateTime <- as.POSIXct(hourlyData[,unixcol], origin="1970-01-01", tz = 'UTC' )
  
  ## remove UNIXtimestamp
  hourlyData <- hourlyData[,-unixcol]
  
  
  ## return
  return(hourlyData)
}

## psqlWriteTable  ---------------------------------------------
psqlWriteDataFrame <- function(con, tablename, value, fieldnames = NA) {
  # Appends data from a dataframe (value) to columns (colnames) 
  # in a table (tablename) in PostgreSQL
  # inputs :
  #   con      : connection to the PSQL databaase
  #   tablename: name of the table to append
  #   value    : dataframe of data to be written
  #   fieldnames : character array defining fields to be written to 
  #              in the psql table where element i refers tot he ith column
  #              of the dataframe. If NA the program will match column names
  #              in the dataframe to field names in the psql table
  
  
  if (is.na(fieldnames) ) {
    # Match field names in psql to column names in the dataframe
    lfields             <- dbListFields(con,tablename)
    fieldsuse           <- colnames(value)[is.element(colnames(value), lfields)]
  } else {
    fieldsuse           <- fieldnames
  }
  
  # create initiarion of SQL query that defines which columns of the table to insert into
  psqlcolnames <- paste('\"', fieldsuse, '\"', collapse=' , ', sep = "")
  psqlstr1 <- paste('INSERT INTO \"', tablename, '\" (', psqlcolnames,') VALUES', sep = "")
  
  # format R data to a proper character form for insertion.  
  valuestrmat <- matrix('', nrow = dim(value)[1], ncol = dim(value)[2])
  for (i in 1:dim(value)[2]){
    
    # check the class of the column
    classvar <- class(value[,i])[1]
    
    # if the class is factor, replace it with appripriate levels
    if (classvar == 'factor'){
      value[,i] <- levels(value[,i])[as.numeric(value[,i])]
      classvar <- class(value[,i])[1]
      
    }
    
    # add quotes around all DATETIME stamps and characters that contain spaces
    if (any(grepl('POSIX', classvar))){
      valuestrmat[,i]  <- paste('TIMESTAMP \'' ,as.character(value[,i]),'\'', sep = "")
      valuestrmat[is.na(value[,i]),i] <- NA
      
      # Add quotes around any character column
    } else if (  classvar == 'character' ) {
      
      valuestrmat[,i]  <- paste('\'' ,as.character(value[,i]),'\'', sep = "")
      valuestrmat[is.na(value[,i]),i] <- NA
      
      # otherwise just create a character from the numeric
    } else {
      valuestrmat[,i] <- as.character(value[,i])
      valuestrmat[is.na(value[,i]),i] <- NA
      
    }
  }
  
  
  # align all the input data to be included in an SQL query 
  valuestrvec = c()                      
  for (i in 1:dim(value)[1]){  
    valuestrtmp <- paste( (valuestrmat[i,]), collapse=',')
    
    valuestrvec <- c(valuestrvec, valuestrtmp)     
    
  }
  valuestr  <- paste('(',valuestrvec,')', sep ="", collapse = ",")
  
  
  # replace all NA values with NULL. 
  valuestr <- gsub('NA','NULL',valuestr)
  
  # load it. 
  psqlloadstr <- paste(psqlstr1, valuestr,';')
  dbGetQuery(con, psqlloadstr)
  
}

