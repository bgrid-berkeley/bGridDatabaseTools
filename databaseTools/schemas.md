## Schemas
Schemas can be considered "subdatabases" in which tables can be assigned. They are useful for (1) keeping the database tidy in that we can tell how dtaabases are grouped by looking at their schema, and (2) controlling access to databases that may fall under non-disclosure agreements etc. 

If starting a new project, please first create a schema in the bgrid database using the following command, then set the authorization to "bGrid" so that other members of the group can access it.  If you're planning on uploading sensitive data you will need to create a separate group for authorization. Authorizations can be changed after creation.

Here is the command for creading a new schema with an authorization (http://www.postgresql.org/docs/8.1/static/ddl-schemas.html)
```psql
CREATE SCHEMA schema_name AUTHORIZATION group_or_user_name; 
```

### Referencing tables in a schema
This is very simple, you just have to reference your table as ``schemaname.tablename``.

I.e., if you are uploading a table of California Zip Code Tabulation Area Polygons (ca_zcta_poly) to the schema containing GIS data (gis_data). You would reference the table as ``gis_data.ca_zcta_poly``.


### Updating the "search_path" 
The search path is a list of schemas that you use, in order of importance. This list is important for a few reasons

* If you ever forget to include the schema name when creating a table it will be placed in the first schema on your search_path.
* If you ever forget to include the schema name when referencing a table, psql will return search for the table through each schema in your search_path sequentially. I.e. you won't see the table if it's not in a schema in your search_path, and if multiple schemas in your search_path contain the tablename, the one from the earliest schema will be returned.
* Many simple tools will only return values for schemas in your search path (i.e. \dt will only list tables for schemas in your search path). 

When you add a new schema you should add it to your search path. By default a schema matching your username is first, so there is no need to add it to your search_path. 

For example, first you can check the existing search path
```sql
SHOW search_path;
```
```
   search_path    
------------------
 "$user", public, topology
(1 row)
```

Then update the search path only for this psql session
```sql
SET search_path TO "$user", gis_data, public, topology;
```
```
SET
```

Or update the default search path for all of your sessions using 
```sql
ALTER USER username SET search_path = "$user",gis_data,public,topology;
```

Then check again
```sql
SHOW search_path;
        search_path         
----------------------------
 "$user", gis_data, public, topology;
(1 row)
```

## Limit access to schema to a group
Below is an example of commands that create a group, add a user to that group, and then grant that group access to a schema. In this case the data are the smart meter data from PG&E stored in the schema pge_data. As of yet only the uploader has access to these data. 

```sql
## Create a group that will have access to the tables
CREATE GROUP pge_group;
GRANT SELECT ON ALL TABLES IN SCHEMA pge_data TO GROUP pge_group;
GRANT USAGE ON SCHEMA pge_data TO GROUP pge_group;

## Add a user to the group
GRANT pge_group TO user;
```
