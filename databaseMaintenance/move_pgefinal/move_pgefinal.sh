#!/bin/bash
## This script moves the database pgefinal from mysql on my maching to psql on switch.db2
# There is one piece that needs to be done by hand, line 44
# Foreign Keys were never added. Which is OK because they enforce restriction on adding rows
# to the PG&E Tables, which we wont be doing.... lest PG&E gives us additional informatoin on top of these!


# Create an alias for accessing the databases in mysql ans psql
alias PGEFINAL_MYSQL="mysql -u root -p$mysqlrootpass pgefinal"
alias BGRID_PSQL="psql --host=switch-db2.erg.berkeley.edu --username=mtabone \
 --dbname=bgrid"

# Create a list variable to store all table names as a list
# http://stackoverflow.com/questions/613572/capturing-multiple-line-output-to-a-bash-variable
declare TABLE_NAMES=($(PGEFINAL_MYSQL -e "show tables;"))

# Output the table definitions from the mysql database 
mysqldump -d -h localhost -u root -p$mysqlrootpass pgefinal --compatible=postgresql > pgefinal_schema.sql

# Create a schema in psql 
# (will throw an error is the schema already exists, the IF NOT EXISTS option 
	# was added in verzion 9.2, we're using 9.0)
BGRID_PSQL -c "CREATE SCHEMA pge_data AUTHORIZATION mtabone;"

# Run the little python script to make table definitions compatible with psql 
# script comes from here: https://github.com/lanyrd/mysql-postgresql-converter
python mysql-postgresql-converter/db_converter.py pgefinal_schema.sql pgefinal_tbldef.psql

# Run an xtra sed command to change floats to numerics
sed s/float/numeric/ < pgefinal_tbldef.psql > pgefinal_tbldef2.psql 
cp pgefinal_tbldef2.psql pgefinal_tbldef.psql

# Run a for loop to change all table names to contain the appropriate schema
# Notice quotes around tablenames but not schema names
tLen=${#TABLE_NAMES[@]}
for (( i = 1; i < $tLen; i++ ));
	do 
	sed s/\"${TABLE_NAMES[i]}\"/pge_data.\"${TABLE_NAMES[i]}\"/ < pgefinal_tbldef.psql > pgefinal_tbldef2.psql 
	cp pgefinal_tbldef2.psql pgefinal_tbldef.psql
done

# Change the default date to be psql compatible
sed s/'0000-00-00 00:00:00'/'1970-01-01 00:00:00 UTC'/ < pgefinal_tbldef.psql > pgefinal_tbldef2.psql 
cp pgefinal_tbldef2.psql pgefinal_tbldef.psql

##################### DID THIS STEP BY HAND! #############################################
# Alternatively you may be able to export everything except the foreign keys from MySQL
#$ Commit transctions before foreign keys 
## Did this by hand by adding ...
#```sql
# COMMIT;
# START TRANSACTION;
#```
## Before the -- Foreign keys -- section

###########################################################################################

# OK Create the tables 
BGRID_PSQL -f pgefinal_tbldef.psql

#################### EVERYTHING WORKS BUT THE FOREIGN KEYS!################################

## Little code to drop all tables if needed 
# for (( i = 1; i < $tLen; i++ ));
#	do 
#	BGRID_PSQL -c "DROP TABLE IF EXISTS pge_data.\"${TABLE_NAMES[i]}\""
# done

### Time to actually move the tables, I'm trying this with one table at first...
## It worked for one table, now I'm automating and running it in a screen so I can see 
## what may have gone wrong. 
tLen=${#TABLE_NAMES[@]}
for (( i = 1; i < $tLen; i++ ));
do 

	# Dump table from mysql to csv in a temporary directory (MySQL has permission issues)
	PGEFINAL_MYSQL -e \
		"SELECT * FROM ${TABLE_NAMES[i]} INTO OUTFILE \
		'/tmp/${TABLE_NAMES[i]}.csv' \
		FIELDS ENCLOSED BY '\"' TERMINATED BY ',' \
		LINES TERMINATED BY '\\r\\n';"

	# Change commonly improper dates to be null, store in a temporary csv then save over the original
	sed 's_\"0000-00-00\"_\\N_' < /tmp/${TABLE_NAMES[i]}.csv > /tmp/tmpcsv.csv 
	cp /tmp/tmpcsv.csv /tmp/${TABLE_NAMES[i]}.csv
	rm /tmp/tmpcsv.csv

	# transfer csv file to server
	scp /tmp/${TABLE_NAMES[i]}.csv  mtabone@switch-db2.erg.berkeley.edu:/home/mtabone/psqlbkp/${TABLE_NAMES[i]}.csv

	# Load into psql 
	BGRID_PSQL -c \
		"COPY pge_data.\"${TABLE_NAMES[i]}\" FROM \
		'/home/mtabone/psqlbkp/${TABLE_NAMES[i]}.csv' \
		DELIMITER ',' CSV NULL '\N'; "

	# remove file from server
	ssh -t mtabone@switch-db2.erg.berkeley.edu "rm /home/mtabone/psqlbkp/${TABLE_NAMES[i]}.csv"

	# Move file into a backup storage directory
	mv /tmp/${TABLE_NAMES[i]}.csv /media/michaelangelo/backups/mysqlbkup/pgefinal_tables/${TABLE_NAMES[i]}.csv
done

############################################################
## Received errors below when importing the weather csvs. 
## I've checked the files, there are no duplicate keys in the .csv files, I don't nknow 
## Why this error is thrown. I'm trying to upload the csv by hand using pgAdmin3

# ERROR:  duplicate key value violates unique constraint "weather_60_pkey"
# DETAIL:  Key (zip5, date)=(93001, 2009-03-08 03:00:00-07) already exists.
# CONTEXT:  COPY weather_60, line 7972: ""93001","44.78","41.49","30.01","3.12","88.81",\N,"0.00",\N,"2009-03-08 03:00:00""
# Connection to switch-db2.erg.berkeley.edu closed.
# weather_60_merged.csv                                                                                       100% 1734MB  51.0MB/s   00:34

# ERROR:  duplicate key value violates unique constraint "weather_60_merged_pkey"
# DETAIL:  Key (zip5, date)=(93001, 2009-03-08 03:00:00-07) already exists.
# CONTEXT:  COPY weather_60_merged, line 7972: ""93001","44.78","41.49","30.01","3.12","88.81",\N,"0.00",\N,"2009-03-08 03:00:00""
# Connection to switch-db2.erg.berkeley.edu closed.
# weather_60_new3.csv                                                                                         100% 1200MB  63.2MB/s   00:19

# ERROR:  duplicate key value violates unique constraint "weather_60_new3_pkey"
# DETAIL:  Key (zip5, date)=(93201, 2009-03-08 03:00:00-07) already exists.
# CONTEXT:  COPY weather_60_new3, line 1348: ""93201","42.04","34.94","30.05","1.00","75.83",\N,"0.00",\N,"2009-03-08 03:00:00""

## Deleted the keys from the tables and will try loading again
tLen=${#TABLE_NAMES[@]}
for (( i = 24; i < $tLen; i++ ));
do 

	# Grab dumped table from the bakup drive
	# transfer csv file to server
	scp /media/michaelangelo/backups/mysqlbkup/pgefinal_tables/${TABLE_NAMES[i]}.csv \
	  mtabone@switch-db2.erg.berkeley.edu:/home/mtabone/psqlbkp/${TABLE_NAMES[i]}.csv

	# Load into psql 
	BGRID_PSQL -c \
		"COPY pge_data.\"${TABLE_NAMES[i]}\" FROM \
		'/home/mtabone/psqlbkp/${TABLE_NAMES[i]}.csv' \
		DELIMITER ',' CSV NULL '\N'; "

	# remove file from server
	ssh -t mtabone@switch-db2.erg.berkeley.edu "rm /home/mtabone/psqlbkp/${TABLE_NAMES[i]}.csv"

done