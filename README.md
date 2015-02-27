# bGridDatabaseTools

## Connecting to the server from the command line 
first, you must ssh into the server, then login to the desired database in PostgreSQL using the command psql
```bash
yourcomp:~$  ssh username@switch-db2.erg.berkeley.edu
username@switch-db2:~$ psql databasename
psql (9.1.14)
Type "help" for help.

databasename=# 
```

Common commands to look around the database
* ``\q`` quits PostgreSQL (or quits a subscreen created by any of the following commands)
* ``\l`` lists all databases
* ``\d`` lists all tables in a database
* ``\d+ tablename`` describes all columns in the table named 'tablename'
* ``\z  tablename`` lists all privileges on the table, http://www.postgresql.org/docs/9.0/static/sql-grant.html


## Setting up pgAdmin3
The server is switch-db2.erg.berkeley.edu
Include your own username and password
Switch ssl to 'require'

## Granting privileges on a database 
We are all members of the group 'dGrid', thus granting privileges to dgrid should grant to everyone.
See http://www.postgresql.org/docs/9.0/static/sql-grant.html for full documentation. 
The following command grants privileges on the database weather_forecastio to dgrid
```sql
GRANT CREATE, CONNECT on DATABASE weather_forecastio TO dgrid;
```

Privileges must be granted separately for each table in a database, even if yuo've changed the database "owner."
The following command grants privileges for selecting and updating tables in the weather_forecastio database, assuming that the user is currently logged in to the weather_forecastio. 
```sql
GRANT SELECT, INSERT, UPDATE on "locations","dailyData","hourlyData" TO dgrid;
```

## Using the weather database (weather_forecastio)

``pgForecastIO.R`` 
contains a set of functions that connect the forecast.io API to the PostgreSQL database on switch-db2 using R. 
The functions can also be used to pull weather information (from the database or the API) into R in general. 

See [pgForecastIO_README.md](https://github.com/bgrid/bGridDatabaseTools/blob/master/pgForecastIO/README.md) or the comments within the file for documentation. 

See [pgForecastIO_driverExample.md](https://github.com/bgrid/bGridDatabaseTools/blob/master/pgForecastIO/pgForecastIO_driverExample.R) for example R code to use the tool. 