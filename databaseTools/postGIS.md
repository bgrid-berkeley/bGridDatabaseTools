# Setting up PostGIS
Our central database is already set up with PostGIS.  If you're creating a separate database for personal use or a local database on your computer, when you're in pgsql simply type:
```
CREATE dbname;
CREATE EXTENSION postgis;
```
or to give an existing database PostGIS capabilities, with the database open just type CREATE EXTENSION postgis;

To add point geometry information to a table, based on latitude and longitude data in the table:
```
ALTER TABLE myschema.mytable ADD COLUMN the_geom geometry;
UPDATE myschema.mytable SET the_geom = ST_MakePoint(CAST(longitude as double precision), CAST(latitude as double precision)); 
ALTER TABLE myschema.mytable ALTER COLUMN the_geom SET NOT NULL;
```

# Importing Shapefiles
To import shapefiles: use shp2pgsql or ogr2ogr
To automatically create a relation and upload a shapefile to the database:
```
shp2pgsql -s SRID shapefile.shp RELATION_NAME | psql --username USERNAME --dbname DBNAME
```
Here is a good man page on the [shp2pgsql]: http://www.bostongis.com/pgsql2shp_shp2pgsql_quickguide.bqg

To check the SRID of the shpfile, you can easily use the following python script. Make sure to have the osgeo package.
```
from osgeo import ogr
driver = ogr.GetDriverByName('ESRI Shapefile')
shape = driver.Open('path/to/my/shapefile.shp')
layer= shape.GetLayer()
sr = layer.GetSpatialRef()

# Try to determine the EPSG/SRID code
res = sr.AutoIdentifyEPSG()
if res == 0: # success
    print('SRID=' + sr.GetAuthorityCode(None))
else:
    print('Could not determine SRID')
```
# External PostGIS Resources:
[Great PostGIS Cheatsheet]
[Importing Shapefiles with shp2pgsql]



[Great PostGIS Cheatsheet]: http://www.postgis.us/downloads/postgis21_cheatsheet.pdf
[Importing Shapefiles with shp2pgsql]: http://suite.opengeo.org/4.1/dataadmin/pgGettingStarted/shp2pgsql.html#dataadmin-pggettingstarted-shp2pgsql



