# bGridDatabaseTools

## Connecting to the server/database(s) from the command line 
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


## Connecting to the database(s) using pgAdmin3
The server is switch-db2.erg.berkeley.edu.
In the setup configuration, include your own username and password and switch ssl to 'require'

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

## Importing a CSV file
The easiest way to import a CSV file from your local drive to the server is through the PGAdmin interface- right-click on a table, choose "import", and follow the associated menu. Be sure to set the type to 'csv' or set the delimiter and indicate whether there is a header.  You will already need to have defined the table with the appropriate variable types

Make sure that the table you're importing to has the same variable names in the same order as in your import file.


## Using PostGis
Creating a new database with PostGis capabilities:
```
CREATE dbname;
CREATE EXTENSION postgis;
```
or to give an existing database PostGis capabilities, with the database open just type CREATE EXTENSION postis;

To add point geometry information to a table, based on latitude and longitude data in the table:
```
ALTER TABLE mytable ADD COLUMN the_geom geometry;
UPDATE mytable SET the_geom = ST_MakePoint(CAST(longitude as double precision), CAST(latitude as double precision)); 
ALTER TABLE mytable ALTER COLUMN the_geom SET NOT NULL;
```
To import shapefiles: use shp2pgsql or ogr2ogr

## Using the weather database (weather_forecastio)

``pgForecastIO.R`` 
contains a set of functions that connect the forecast.io API to the PostgreSQL database on switch-db2 using R. 
The functions can also be used to pull weather information (from the database or the API) into R in general. 

See [pgForecastIO_README.md](https://github.com/bgrid/bGridDatabaseTools/blob/master/pgForecastIO/) or the comments within the file for documentation. 

See [pgForecastIO_driverExample.md](https://github.com/bgrid/bGridDatabaseTools/blob/master/pgForecastIO/pgForecastIO_driverExample.R) for example R code to use the tool. 
