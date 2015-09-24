# Migrating the Postgres Database
## Installing Postgresql 
Followed instruction under **PostgreSQL Apt Repository** on http://www.postgresql.org/download/linux/ubuntu/. 

Then I created a role for myself 
```bash 
sudo su potgres
psql
```

```psql
CREATE ROLE [username] WITH SUPERUSER LOGIN PASSWORD 'password'
CREATE DATABASE bgrid
\q
```

## Installing PostGIS
This had to be done separately for some reason. 
```bash 
sudo apt-get install postgresql-9.4-postgis-2.1
```

## Dumping data from switch 
First I had to dump the database to a file. This requires having the ~/.pgpass file set up http://www.postgresql.org/docs/9.3/static/libpq-pgpass.html. 
 
```bash
pg_dump -U [username] -h [hostname] bgrid > bgrid_bkup.psql
```

Second I dumped all of the role definitions. I then edited this file to include only those entries relevant to the bGrid database. This requires using `pg_dumpall` which accesses information for all databases. 

```bash 
pg_dumpall -U [username] -h [hostname] --roles-only > bgrid_bkup_roles.psql
```

## Loading data into bgrid
First, I used ftp to transfer the dump files to the new server, then I loaded the roles, then I loaded the data. 
```bash
psql bgrid < bgrid_bkup_roles.psql
psql bgrid < bgrid_bkup.psql
```
