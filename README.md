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

## Granting permissions on a database 
We are all members of the group 'dGrid', thus granting permissions to dgrid should grant to everyone.
See http://www.postgresql.org/docs/9.0/static/sql-grant.html for full documentation. 
The following command grants permission on the database weather_forecastio to dgrid
```sql
GRANT CREATE, CONNECT on DATABASE weather_forecastio TO dgrid;
```

Permissions must be granted separately for each table in a database, even if yo've changed the database "owner."
The following command grants permission of selecting and updating tables in the weather_forecastio database, assuming that the user is currently logged in to the weather_forecastio. 

```sql
GRANT SELECT, INSERT, UPDATE on "locations","dailyData","hourlyData" TO dgrid;
```
