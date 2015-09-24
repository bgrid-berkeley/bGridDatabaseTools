## What is a tablespace? 
A tablespace is a pointer to a directory on your machine where PostgreSQL stored the data in a table or indes.   On Peter's bgrid.lbl.gov server there are effectively two disks, one fast solid state drive (SSD), and four spinning hard drive that are mounted (using RAID5) as one hard drive with redundancies. 

## Tablespaces on bgrid
We will have two tablespaces in PSQL on the bgrid server
* 'ts_spin'     is the tablespace pointing to a directory on the spinning hard disk and 
* 'ts_ssd'      is the tablespace pointing to a directory on the SSD. 

Following the advice on a message board (link below) we will store all data on the spinning drive and the indexes on the SSD. If we have a table with relatively little data (to the storage space of the SSD) which get read and written to a lot, we can store it on the SSD as needed. Tables can also be moved to the SSD temporarily "as needed." 

## Creating tablespaces
Tablespaces are created using the psql command `CREATE TABLESPACE`  commands creating tablespaces for bgrid are included below. See PostgreSQL manual for more information: http://www.postgresql.org/docs/9.2/static/manage-ag-tablespaces.html. 


Directories were created at the command line, and ownership was changed to the Ubuntu user "postgres" 

```
CREATE TABLESPACE ts_ssd OWNER postgres LOCATION  '/pgdata';
CREATE TABLESPACE ts_spin OWNER postgres LOCATION '/meida/spin/pgdata';

```

## Moving tables and indexes between tablespaces
Tables and indexes are stored separately.  They can be moved between tablespaces using either `ALTER TABLE' or 'ALTER INDEX'. The following commands will move all indexes to the ts_ssd table space and all tables to the ts_spin tablespace. 

```
SELECT ' ALTER TABLE '||schemaname||'.'||tablename||' SET TABLESPACE ts_spin;' from pg_tables;
SELECT ' ALTER INDEX '||schemaname||'.'||indexname||' SET TABLESPACE ts_ssd;' FROM pg_indexes;
```
