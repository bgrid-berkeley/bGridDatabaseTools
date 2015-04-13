## Load required libraries and source the file with the database functions
require(RPostgreSQL)

## Setup the postgresql driver
drv <- dbDriver("PostgreSQL")

## Get psql password
psqlpass <- Sys.getenv('sw2_psql_password')

## Tunnel

# This is a unix command that connects port 5433 on your computer to port 5432 
# on switch-db2 securely. It works over ssh, which authenticates with RSA keys. 
# So you will have to have an and RSA key from your current computer stored in the 
# ~/.ssh/authorized_keys file on the server. 

# 5433:localhost will act just like switch-db2.erg.berkeley.edu:5432 and there
# is no need to worry about security etc. 

# system() runs a command on your system bash and returns the output
system('ssh -f mtabone@switch-db2.erg.berkeley.edu -L 5433:localhost:5432 -N')


# R will now connect to 5433 on the localhost. No need to refer to the server. 
wcon <- dbConnect(drv, user ="mtabone", pass = psqlpass, dbname="bgrid", host="localhost", port=5433)

# get some output to check 
out <- dbGetQuery(wcon, 'select * from weather_forecastio."hourlyData" where "locId" = 1')

head(out)
