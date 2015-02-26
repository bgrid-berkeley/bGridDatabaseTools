# bGridDatabaseTools

## Connecting to the server from the command line 
first, you must 

## Granting permissions on a database 
We are all members of the group 'dGrid', thus granting permissions to dgrid should grant to everyone.
See http://www.postgresql.org/docs/9.0/static/sql-grant.html for full documentation. 
The following command grants permission on the database weather_forecastio to dgrid
`GRANT CREATE, CONNECT on DATABASE weather_forecastio TO dgrid;'

Permissions must be granted separately for each table in a database, despite the database "owner"
The following command grants permission of selecting and updating tables in the weather_forecastio database, assuming that the user is currently logged on to this database. 
GRANT SELECT, INSERT, UPDATE on "locations","dailyData","hourlyData" TO dgrid;
