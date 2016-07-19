# Migrating data fom mySQL to PostgreSQL on bGrid. 
Written by MT. 

I couldn't  get any of the out-of-the-box tools to work, though they are listed here: https://wiki.postgresql.org/wiki/Converting_from_other_Databases_to_PostgreSQL
Maybe between now and the time you look at this they will be updated and more user-friendly. 

I ended up doing quite a bit of manual labor for this migration. 
* Export table definitions from mysql in a "psql friendly" manner. 
* Make further edits to these definitions to make them actually psql friendly (including removing keys)
* Load table defitions into psql. 
* Export data from tables into .csv files
* Load data into psql, often having to further edit the table definitions
* Replace keys that were removed.
* Add auto-increments where necessary. 
 
## Export table definitions
The following shell command exports the table definitions
```bash 
mysqldump dbname -u root -p --compatible=postgresql --no-data > /path/to/file.sql
```

## Edit table definitions 
Edit the data type definitions. 
* tinyint to int
* int(*) to int 
* smallint to int
* bigint to int
* datetime to timestamp with time zone 
* float to double
* numeric to double 

Default timestamps in mysql are sometimes `00:00:00 00-00-00`, these need to be changed. I changed them to null, which I think is more appropriate. I removed a not null constraint when necessary. 

Remove all keys (you'll need to add them later) 

Add a schema name before each table name.

## Run table definition scripts in psql
Edit definitions when necessary. 

## Export data to csv files
Sometimes there are many tables in a database, but I still want to export each individually to a csv file. 
Given the table names, this bash scrips will do this export and dump it in the `\tmp` directory. Note that password to the mysql database is saved as an environment variable: mysqlpass.  If the mysql database is on a remote server it's best to export the files there and then ftp them when you're done. 


```bash
tables=(table0 table1 table2 table3)  

for i in `seq 0 3`;
do
	mysql dbname -u root -p$mysqlpass -e "SELECT * from ${tables[i]} INTO OUTFILE '/tmp/${tables[i]}.csv' FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"' LINES TERMINATED BY '\n';"
done   
```

## Import csv to PostgreSQL. 
You may need to ftp the csv files to the server to do this.  If there aren't too many files you can also use the data import function in pgAdmin3. 

I rewrote the bash loop from above to do the loading. Where the database name from mysql is not a schema_name in psql.  All data are stored in the same bgrid2 database. 
```bash
for i in `seq 0 3`;
do
	psql bgrid2 --port=5435 -U mtabone --host=127.0.0.1 -c "COPY schema_name.\"${tables[i]}\" FROM '/tmp/${tables[i]}.csv' DELIMITER ',' CSV;"
done    

```
