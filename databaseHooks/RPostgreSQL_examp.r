## Load required libraries 
require(RPostgreSQL)
require(ggplot2)

## Setup the postgresql driver
drv <- dbDriver("PostgreSQL")

## Get psql password
psqlpass <- Sys.getenv('sw2_psql_password')

## Tunnel

# This is a unix command that connects port 5433 on your computer to port 5432 
# on switch-db2 securely. It works over ssh, which authenticates with RSA keys. 
# So you will have to have an RSA key on your current computer, and the public
# file for this rda key "id_rsa.pub" copy and pasted onto a line in the
# ~/.ssh/authorized_keys file on the server. 

# Once the tunnel is set up. localhost:5433 will act just like 
# switch-db2.erg.berkeley.edu:5432 

# system() runs a command on your system bash and returns the output
system('ssh -f mtabone@switch-db2.erg.berkeley.edu -L 5433:localhost:5432 -N')

# R will now connect to 5433 on the localhost. No need to refer to the server. 
# The connection is stored in a variable "wcon"
wcon <- dbConnect(drv, user ="mtabone", pass = psqlpass, dbname="bgrid", host="localhost", port=5433)

# choose a location id to start 
locId = 10

# get some output to check 
psqlQuery = paste('select * from weather_forecastio."hourlyData" where "locId" = ',locId)
weather <- dbGetQuery(wcon, psqlQuery)

# check out what the data look like
head(weather)

# Say we want to create a table of total heating degree hours and cooling degree hours for each day

# Add a column of hourly heating degree hours (from 65F) and cooling degree hours (above 75F)
weather$hdh65 <- pmax(0, -weather$temperature + 65)
weather$cdh75 <- pmax(0, +weather$temperature - 75)

## ggplot the temperature, HDH and CDH
ggplot(data = weather) + 
  geom_line(aes( x = dateTime, y = hdh65, color = 'HDH' )) + 
  geom_line(aes( x = dateTime, y = cdh75, color = 'CDH')) + 
  geom_line(aes( x = dateTime, y = temperature, color = 'Temp' )) 

## Create a daily table 
# round the dateTime stamps to be dates
weather$date   <-  as.factor(as.character(round(weather$dateTime, units = 'days')))
weatherMTdaily <-  aggregate(weather[,c('hdh65','cdh75')], by = list(weather$date), FUN = sum)

# put the location id in the table 
weatherMTdaily$locId <- locId;

# rename and rearrange columns 
weatherMTdaily$date <- as.POSIXct(weatherMTdaily$Group.1)
weatherMTdaily <- weatherMTdaily[,c('locId','date','hdh65','cdh75')]
rownames(weatherMTdaily) <- c()

## ggplot the temperature, HDH and CHD
ggplot(data = weatherMTdaily) + 
  geom_line(aes( x = date, y = hdh65, color = 'HDH' )) + 
  geom_line(aes( x = date, y = cdh75, color = 'CDH')) 

## write table to psql dbL
# if the table exists, this will append it. 
# conn   :  the database connection you're using 
# name   :  a character array, the first element is the schema, the second is the table name 
# value  : the data.frame you're uploading 
# append : is a logical asking whether data should be appended to the table (if it exists)
dbWriteTable( conn = wcon, name = c('mtabone','degreeDays'), value = weatherMTdaily, append = TRUE)

# This is generally a mess... there is no primary key on this table, there can be duplicate entries etc. 
# In general it may be better to input your data by defining the table first and then constructing an SQL query. 
# We will work on that another day. 